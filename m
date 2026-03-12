Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE7E3101AD;
	Thu, 12 Mar 2026 08:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302921; cv=none; b=cMDrtRhvSca2+EgXbQ0pEnRxBbcNKA+MH8Q/iazAG2g2wkPOPLgrFC9Yj8xPaDO8TQEzfbe3sIuyl9UurHukqxM8NdAd1cCCUXGYX2RW+2dRcUP+Nl2soIrzBtahZ7Ec8Jp11wsar0Yp/mnMb5snT/xmYkHokpqTQVd8hGY33JA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302921; c=relaxed/simple;
	bh=AIcxrskhjV16J/y4kRg5qatXDqQyVjJGwRlt50pWiKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ba9AYgHIOMHYEHB9bnlT0YH07jYFuSR+yvGqHWD60jkSCXwbGIcYeU49edVWfav+MNYFimxNM4Gf+CWW8yjaJfT/9lv/i9FHAac0q2pfiXUswUZySPb73fiig7Pa1lutaY+k30jDKLP0AdggqaCJJWcTjfSfeQj31gJZ7TWXiy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ayvQ7Uvv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ayvQ7Uvv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7DEC4CEF7;
	Thu, 12 Mar 2026 08:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302921;
	bh=AIcxrskhjV16J/y4kRg5qatXDqQyVjJGwRlt50pWiKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ayvQ7UvvPq4elBLij/SRIpZIdDFu7ZLLrsbHYazSTYTqPacXPZfPG04hNmFUP0I/s
	 GbjosUxybE01/WKg7EjbnWOPCT6YFO1vVCNmRMl9QVdirOcfELBjN3IS9KmB99GxQW
	 iG7aqivKPXsBKDGIvPtkzLFxKJsnWr9Fzrgdu1WANvfyB+12Kqf9Nwesi4dZBaWmN4
	 uqZMCTG85cgf9LhVCNI0vSd3gkRCFe62Ec4zDSw0Ow7xBJZ+2qDsEFS67kkPjUmTJ0
	 uBXe/6AKTIikizP527IvPoXbT7PZ9NsERXusIXHVLYKTo38TQWhozfhJy7vWv/wcCd
	 zwPLmz1V0+6PQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v3 08/12] coco: host: KVM: arm64: Handle vdev request exits and completion
Date: Thu, 12 Mar 2026 13:37:39 +0530
Message-ID: <20260312080743.3487326-9-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080743.3487326-1-aneesh.kumar@kernel.org>
References: <20260312080743.3487326-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- add the RMI/RHI definitions for RMI_VDEV_COMPLETE, the new exit
  reason, and the extended REC exit payload
- update KVM to recognize RMI_EXIT_VDEV_REQUEST and surface it to
  userspace via KVM_EXIT_ARM64_TIO
- Add CCA TSM guest request handler for __REC_EXIT_DA_VDEV_REQUEST which
  takes a vCPU fd and verify it belongs to the same VM before calling
  rmi_vdev_complete()

This lets Realm firmware hand control back to the VMM when it needs host
assistance for vdev operations, and gives userspace a way to finish the
request.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 Documentation/virt/kvm/api.rst           | 22 +++++++++++++++++
 arch/arm64/include/asm/rhi.h             |  1 +
 arch/arm64/include/asm/rmi_cmds.h        | 10 ++++++++
 arch/arm64/include/asm/rmi_smc.h         | 17 ++++++++++++--
 arch/arm64/include/uapi/asm/rmi-da.h     |  5 ++++
 arch/arm64/kvm/rmi-exit.c                | 17 ++++++++++++++
 drivers/virt/coco/arm-cca-host/arm-cca.c | 12 ++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  | 30 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  2 ++
 include/linux/kvm_host.h                 |  1 +
 include/uapi/linux/kvm.h                 | 10 ++++++++
 virt/kvm/kvm_main.c                      |  6 +++++
 12 files changed, 131 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index bd2f0dd0aeda..041009307ee8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7429,6 +7429,28 @@ the ``KVM_EXIT_ARM_SEA_FLAG_GPA_VALID`` flag is set. Otherwise, the value of
 ``gpa`` is unknown.
 
 ::
+		/* KVM_EXIT_ARM64_TIO*/
+		struct {
+			__u64 flags;
+			__u64 nr;
+			__u64 vdev_id;
+			__u64 gpa_base;
+			__u64 gpa_top;
+			__u64 pa_base;
+		} cca_exit;
+
+Used on arm64 systems. When the VM capability ``KVM_CAP_ARM_RMI`` is enabled,
+KVM generates a VM exit whenever the guest needs host assistance to map a vdev
+ID to a vdev object, or to validate a device-memory GPA-to-PA mapping. The
+``nr`` field records the exit reason; currently the following values are
+defined:
+
+* ``RMI_EXIT_VDEV_REQUEST``: the RMM is requiring host to provide the vdev
+  object details matching a specific virtual device id.
+* ``RMI_EXIT_VDEV_MAP``: the guest wants the host to validate or install a
+  device-memory mapping.
+
+The ``flags`` field must be zero.
 
 		/* Fix the size of the union. */
 		char padding[256];
diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index a18ad7bbc028..888b3a1c3953 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -84,5 +84,6 @@ enum rhi_tdi_state {
 #define __RHI_DA_OBJECT_READ		0x2
 #define __RHI_DA_VDEV_GET_INTERFACE_REPORT 0x3
 #define __RHI_DA_VDEV_GET_MEASUREMENTS	0x4
+#define __REC_EXIT_DA_VDEV_REQUEST	0x5
 
 #endif
diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index aad245675c7d..f29c2de5d3b9 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -685,4 +685,14 @@ rmi_vdev_get_device_measurements(unsigned long rd, unsigned long pdev_phys,
 
 	return res.a0;
 }
+
+static inline unsigned long rmi_vdev_complete(unsigned long rec_phys, unsigned long vdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_COMPLETE, rec_phys, vdev_phys, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 36c3db8b821d..6b685585e750 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -60,6 +60,7 @@
 #define SMC_RMI_VDEV_DESTROY		SMC_RMI_CALL(0x0188)
 #define SMC_RMI_VDEV_GET_STATE		SMC_RMI_CALL(0x0189)
 #define SMC_RMI_VDEV_UNLOCK		SMC_RMI_CALL(0x018A)
+#define SMC_RMI_VDEV_COMPLETE		SMC_RMI_CALL(0x018e)
 #define SMC_RMI_VDEV_GET_INTERFACE_REPORT SMC_RMI_CALL(0x01D0)
 #define SMC_RMI_VDEV_GET_DEV_MEASUREMENTS	SMC_RMI_CALL(0x01D1)
 #define SMC_RMI_VDEV_LOCK		SMC_RMI_CALL(0x01D2)
@@ -225,6 +226,7 @@ struct rec_enter {
 #define RMI_EXIT_RIPAS_CHANGE		0x04
 #define RMI_EXIT_HOST_CALL		0x05
 #define RMI_EXIT_SERROR			0x06
+#define RMI_EXIT_VDEV_REQUEST		0x08
 
 struct rec_exit {
 	union { /* 0x000 */
@@ -266,12 +268,23 @@ struct rec_exit {
 			u64 ripas_base;
 			u64 ripas_top;
 			u8 ripas_value;
-			u8 padding8[7];
+			u8 padding8[15];
+			u64 s2ap_base;
+			u64 s2ap_top;
+			u64 vdev_id_1;
+			u64 vdev_id_2;
+			u64 dev_mem_base;
+			u64 dev_mem_top;
+			u64 dev_mem_pa;
 		};
 		u8 padding5[0x100];
 	};
 	union { /* 0x600 */
-		u16 imm;
+		struct {
+			u16 imm;
+			u8 padding[6];
+			u64 plane;
+		};
 		u8 padding6[0x100];
 	};
 	union { /* 0x700 */
diff --git a/arch/arm64/include/uapi/asm/rmi-da.h b/arch/arm64/include/uapi/asm/rmi-da.h
index 1c21a5e78eb5..ac6e2fd2807d 100644
--- a/arch/arm64/include/uapi/asm/rmi-da.h
+++ b/arch/arm64/include/uapi/asm/rmi-da.h
@@ -22,4 +22,9 @@ struct arm64_vdev_device_measurement_guest_req {
 	__aligned_u64 nonce;
 };
 
+struct arm64_vdev_device_idmap_guest_req {
+	__u32 req_type;
+	__s32 vcpu_fd;
+};
+
 #endif
diff --git a/arch/arm64/kvm/rmi-exit.c b/arch/arm64/kvm/rmi-exit.c
index 7eff6967530c..3bba5e6afe88 100644
--- a/arch/arm64/kvm/rmi-exit.c
+++ b/arch/arm64/kvm/rmi-exit.c
@@ -129,6 +129,21 @@ static int rec_exit_host_call(struct kvm_vcpu *vcpu)
 	return kvm_smccc_call_handler(vcpu);
 }
 
+static inline void kvm_prepare_vdev_request_exit(struct kvm_vcpu *vcpu, unsigned long vdev_id)
+{
+	vcpu->run->exit_reason = KVM_EXIT_ARM64_TIO;
+	vcpu->run->cca_exit.nr = RMI_EXIT_VDEV_REQUEST;
+	vcpu->run->cca_exit.vdev_id  = vdev_id;
+	vcpu->run->cca_exit.flags = 0;
+}
+
+static int rec_exit_vdev_request(struct kvm_vcpu *vcpu)
+{
+	struct realm_rec *rec = &vcpu->arch.rec;
+
+	kvm_prepare_vdev_request_exit(vcpu, rec->run->exit.vdev_id_1);
+	return 0;
+}
 static void update_arch_timer_irq_lines(struct kvm_vcpu *vcpu)
 {
 	struct realm_rec *rec = &vcpu->arch.rec;
@@ -198,6 +213,8 @@ int handle_rec_exit(struct kvm_vcpu *vcpu, int rec_run_ret)
 		return rec_exit_ripas_change(vcpu);
 	case RMI_EXIT_HOST_CALL:
 		return rec_exit_host_call(vcpu);
+	case RMI_EXIT_VDEV_REQUEST:
+		return rec_exit_vdev_request(vcpu);
 	}
 
 	kvm_pr_unimpl("Unsupported exit reason: %u\n",
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index ba2751eb06f7..8aa362f44090 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -362,6 +362,18 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi, enum pci_tsm_req_scope sco
 							       (u8 *)req_obj.nonce);
 			return ret;
 		}
+		case __REC_EXIT_DA_VDEV_REQUEST:
+		{
+			struct arm64_vdev_device_idmap_guest_req req_obj;
+
+			if (req_len != sizeof(req_obj))
+				return -EINVAL;
+
+			if (copy_from_user((void *)&req_obj, req.user, req_len))
+				return -EFAULT;
+
+			return cca_vdev_device_request(pdev, req_obj.vcpu_fd);
+		}
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 58a20877c6b6..3c19dfe89c0a 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -1078,3 +1078,33 @@ int cca_vdev_get_device_measurements(struct pci_dev *pdev, unsigned long flags,
 	/* get and update the interface report cache. */
 	return vdev_update_device_measurements_cache(pdev);
 }
+
+int cca_vdev_device_request(struct pci_dev *pdev, unsigned long vcpu_fd)
+{
+	struct kvm *kvm;
+	struct kvm_vcpu *vcpu;
+	unsigned long rec_phys;
+	struct cca_host_tdi *host_tdi = NULL;
+	struct file *vcpu_filp __free(fput) = fget(vcpu_fd);
+
+	if (!file_is_vcpu(vcpu_filp))
+		return -EINVAL;
+
+	vcpu = vcpu_filp->private_data;
+	if (!vcpu)
+		return -EINVAL;
+
+	rec_phys = virt_to_phys(vcpu->arch.rec.rec_page);
+	host_tdi = to_cca_host_tdi(pdev);
+	if (!host_tdi)
+		return -EINVAL;
+
+	kvm = host_tdi->tdi.kvm;
+	/* make sure this is the same vm */
+	if (vcpu->kvm != kvm)
+		return -EINVAL;
+
+	if (rmi_vdev_complete(rec_phys, virt_to_phys(host_tdi->rmm_vdev)))
+		return -ENXIO;
+	return 0;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 6304cee85874..2547afa1256f 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -93,6 +93,7 @@ struct cca_host_tdi {
 	struct pci_tdi tdi;
 	struct realm *realm;
 	void *rmm_vdev;
+	unsigned long vdev_id;
 	/* protected by cca_host_pf0_dsc.object_lock */
 	struct cache_object *interface_report;
 	struct cache_object *measurements;
@@ -152,4 +153,5 @@ int cca_vdev_read_cached_object(struct pci_dev *pdev, int type, unsigned long of
 				unsigned long max_len, void __user *user_buf);
 int cca_vdev_get_interface_report(struct pci_dev *pdev);
 int cca_vdev_get_device_measurements(struct pci_dev *pdev, unsigned long flags, u8 *nonce);
+int cca_vdev_device_request(struct pci_dev *pdev, unsigned long rec_id);
 #endif
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 34759a262b28..26a9619c364c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1066,6 +1066,7 @@ void kvm_get_kvm(struct kvm *kvm);
 bool kvm_get_kvm_safe(struct kvm *kvm);
 void kvm_put_kvm(struct kvm *kvm);
 bool file_is_kvm(struct file *file);
+bool file_is_vcpu(struct file *file);
 void kvm_put_kvm_no_destroy(struct kvm *kvm);
 
 static inline struct kvm_memslots *__kvm_memslots(struct kvm *kvm, int as_id)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 49d5ce0b7a26..c2e12a1bb23b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -188,6 +188,7 @@ struct kvm_exit_snp_req_certs {
 #define KVM_EXIT_ARM_SEA          41
 #define KVM_EXIT_ARM_LDST64B      42
 #define KVM_EXIT_SNP_REQ_CERTS    43
+#define KVM_EXIT_ARM64_TIO	  44
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -492,6 +493,15 @@ struct kvm_run {
 		} arm_sea;
 		/* KVM_EXIT_SNP_REQ_CERTS */
 		struct kvm_exit_snp_req_certs snp_req_certs;
+		/* KVM_EXIT_ARM64_TIO*/
+		struct {
+			__u64 flags;
+			__u64 nr;
+			__u64 vdev_id;
+			__u64 gpa_base;
+			__u64 gpa_top;
+			__u64 pa_base;
+		} cca_exit;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index f076c5a7a290..229c2b14bc83 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -4110,6 +4110,12 @@ static struct file_operations kvm_vcpu_fops = {
 	KVM_COMPAT(kvm_vcpu_compat_ioctl),
 };
 
+bool file_is_vcpu(struct file *file)
+{
+	return file && file->f_op == &kvm_vcpu_fops;
+}
+EXPORT_SYMBOL_GPL(file_is_vcpu);
+
 /*
  * Allocates an inode for the vcpu.
  */
-- 
2.43.0

