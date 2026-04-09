Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74623DF010;
	Thu,  9 Apr 2026 15:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748554; cv=none; b=c3YvlNFli5xdZxacOe3oa52HSIai0IhiMNFuypt0Z1t8ui0ozlXmV5cY0Jc8kaw/sl/DIFraJ3hJAQGA8cEqFYRXy7xk74pXR015DBIusUvLdodJ9YbaR6WFmJL9BXkboD7PneVHv4qFUiCIEEAerRyvT45jfIqqPQf89qsWZqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748554; c=relaxed/simple;
	bh=efHZCN1DJrFqL1fSQk1MrwRRN8zq1AkJYsw8UqbcTMw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sIlqQweAXomGif7/babY1WMXX2+D6M+DePgIXO/GVybhzbCzfpzBr79/LNj/kFaTZYgJzuWYHCrFxy3yV9GkB28HddRUTVrwxyJSbDdd2z/numYSFqWg6/sqwHr8U8fu3VGo+1qIbmCJMg8fG4gYaZC/77DrFIT9x578ZReY/P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n1/wrVAs; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n1/wrVAs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bhFlBoSxjJMIlReh1caBfDI3G8k5kHCJIUA4Zgiq094=; b=n1/wrVAsdN9fGhc8RZ64w59501
	RFjiXhsGPvJzLhzK66hPBeOi7W+SHeD7X8qh5O2wlDWC7wVaRt0ioegU4bmrGwj8VjiZNKmhq2vp9
	1JkWLD12veXOidcn7xGiUciTe541y6cF15mBmXHPu9gYkNn/R9yViA7ODqi52uUTKvyGhvxgmPMtT
	72bZhf7cCX7E0TIvaduKJQJFZnuq7dgHqhPCQ4Fhah6rg8Qw5uMV8CZim5gT6DKfy5Ui8KR5/dst6
	n28Og+N+m819DFgtltBDr8sGxLlg+Z9fE4V33HMXv0fpx1384DYweuuLO/gxek+f42LpkV6KZEkfU
	+B3av7kA==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wArJa-0000000BzQE-3Uqh;
	Thu, 09 Apr 2026 15:29:06 +0000
Message-ID: <7fb7b823c68e04321eb532a5b8ae21a818d4926d.camel@infradead.org>
Subject: [PATCH] KVM: arm64: Add KVM_CAP_ARM_NATIVE_CACHE_CONFIG vcpu
 capability
From: David Woodhouse <dwmw2@infradead.org>
To: akihiko.odaki@daynix.com, "Gutierrez Cantu, Bernardo"
 <bercantu@amazon.de>
Cc: alexandru.elisei@arm.com, alyssa@rosenzweig.io, asahi@lists.linux.dev, 
	broonie@kernel.org, catalin.marinas@arm.com, james.morse@arm.com, 
	kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	marcan@marcan.st, mathieu.poirier@linaro.org, maz@kernel.org, 
	oliver.upton@linux.dev, suzuki.poulose@arm.com, sven@svenpeter.dev, 
	will@kernel.org
Date: Thu, 09 Apr 2026 16:29:06 +0100
In-Reply-To: <b71910e202ac4a56a87c0e34df13cce058d46a76.camel@infradead.org>
References: <b71910e202ac4a56a87c0e34df13cce058d46a76.camel@infradead.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-fUCIPL1EFDn51viUi3G3"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-fUCIPL1EFDn51viUi3G3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: David Woodhouse <dwmw@amazon.co.uk>

Commit 7af0c2534f4c5 ("KVM: arm64: Normalize cache configuration")
fabricates CLIDR_EL1 and CCSIDR_EL1 values instead of using the real
hardware values. While this provides consistent values across
heterogeneous CPUs, it does cause visible changes in the CPU model
exposed to guests.

The commit claims that userspace can restore the original values, but
there is no way for userspace to obtain the real CLIDR_EL1 register
value =E2=80=94 it is not fully reconstructible from sysfs, which lacks the
LoC, LoUU, and LoUIS fields.

Add a per-vcpu KVM_CAP_ARM_NATIVE_CACHE_CONFIG capability that reads
the real CLIDR_EL1 and all CCSIDR_EL1 values from the current physical
CPU and sets them on the vcpu.

This allows hypervisors to present the real hardware cache configuration
to guests, which is important for consistency of the environment across
kernel versions and for migration compatibility with hosts running
older kernels that exposed the real values.

Fixes: 7af0c2534f4c ("KVM: arm64: Normalize cache configuration")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 Documentation/virt/kvm/api.rst                | 23 ++++++++
 arch/arm64/include/asm/kvm_host.h             |  1 +
 arch/arm64/kvm/arm.c                          | 17 ++++++
 arch/arm64/kvm/sys_regs.c                     | 26 ++++++++++
 include/uapi/linux/kvm.h                      |  1 +
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../selftests/kvm/arm64/native_cache_config.c | 52 +++++++++++++++++++
 7 files changed, 121 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/native_cache_config.c

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t
index e3b3bd9edeec..ee47dc07ceac 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8930,6 +8930,29 @@ no-op.
=20
 ``KVM_CHECK_EXTENSION`` returns the bitmask of exits that can be disabled.
=20
+7.48 KVM_CAP_ARM_NATIVE_CACHE_CONFIG
+-------------------------------------
+
+:Architecture: arm64
+:Target: vcpu
+:Parameters: none
+:Returns: 0 on success, -ENOMEM on allocation failure, -EINVAL if
+          args[0] or flags are non-zero.
+
+This per-vcpu capability reads the real CLIDR_EL1 and CCSIDR_EL1 values
+from the physical CPU on which the ioctl is executed, and sets them on
+the vcpu. This replaces the fabricated cache configuration that KVM
+provides by default.
+
+The caller should ensure the vcpu thread is pinned to the desired
+physical CPU before invoking this capability, so that the correct cache
+topology is captured. On heterogeneous systems, different physical CPUs
+may have different cache configurations.
+
+After this capability is enabled, the vcpu's CLIDR_EL1 and CCSIDR_EL1
+values can still be overridden individually via ``KVM_SET_ONE_REG`` and
+the ``KVM_REG_ARM_DEMUX`` interface.
+
 8. Other capabilities.
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=20
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h
index a1bb025c641f..c9713a472c47 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1296,6 +1296,7 @@ void kvm_sys_regs_create_debugfs(struct kvm *kvm);
 void kvm_reset_sys_regs(struct kvm_vcpu *vcpu);
=20
 int __init kvm_sys_reg_table_init(void);
+int kvm_vcpu_set_native_cache_config(struct kvm_vcpu *vcpu);
 struct sys_reg_desc;
 int __init populate_sysreg_config(const struct sys_reg_desc *sr,
 				  unsigned int idx);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 326a99fea753..579583e8dc5c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -393,6 +393,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long=
 ext)
 	case KVM_CAP_ARM_DISABLE_EXITS:
 		r =3D KVM_ARM_DISABLE_VALID_EXITS;
 		break;
+	case KVM_CAP_ARM_NATIVE_CACHE_CONFIG:
+	case KVM_CAP_ENABLE_CAP:
+		r =3D 1;
+		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
 		return KVM_GUESTDBG_VALID_MASK;
 	case KVM_CAP_ARM_SET_DEVICE_ADDR:
@@ -1793,6 +1797,19 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r =3D kvm_arch_vcpu_ioctl_vcpu_init(vcpu, &init);
 		break;
 	}
+	case KVM_ENABLE_CAP: {
+		struct kvm_enable_cap cap;
+
+		r =3D -EFAULT;
+		if (copy_from_user(&cap, argp, sizeof(cap)))
+			break;
+
+		r =3D -EINVAL;
+		if (cap.cap =3D=3D KVM_CAP_ARM_NATIVE_CACHE_CONFIG &&
+		    !cap.args[0] && !cap.flags)
+			r =3D kvm_vcpu_set_native_cache_config(vcpu);
+		break;
+	}
 	case KVM_SET_ONE_REG:
 	case KVM_GET_ONE_REG: {
 		struct kvm_one_reg reg;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1b4cacb6e918..c19d84e48f8b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -484,6 +484,32 @@ static int set_ccsidr(struct kvm_vcpu *vcpu, u32 cssel=
r, u32 val)
 	return 0;
 }
=20
+int kvm_vcpu_set_native_cache_config(struct kvm_vcpu *vcpu)
+{
+	u32 csselr;
+
+	if (!vcpu->arch.ccsidr) {
+		vcpu->arch.ccsidr =3D kmalloc_array(CSSELR_MAX, sizeof(u32),
+						  GFP_KERNEL_ACCOUNT);
+		if (!vcpu->arch.ccsidr)
+			return -ENOMEM;
+	}
+
+	local_irq_disable();
+
+	__vcpu_assign_sys_reg(vcpu, CLIDR_EL1, read_sysreg(clidr_el1));
+
+	for (csselr =3D 0; csselr < CSSELR_MAX; csselr++) {
+		write_sysreg(csselr, csselr_el1);
+		isb();
+		vcpu->arch.ccsidr[csselr] =3D read_sysreg(ccsidr_el1);
+	}
+
+	local_irq_enable();
+
+	return 0;
+}
+
 static bool access_rw(struct kvm_vcpu *vcpu,
 		      struct sys_reg_params *p,
 		      const struct sys_reg_desc *r)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 694cf699ed0a..2d8bbb4dd69b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -995,6 +995,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_USER_OPEREXEC 246
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_ARM_DISABLE_EXITS 248
+#define KVM_CAP_ARM_NATIVE_CACHE_CONFIG 249
=20
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selft=
ests/kvm/Makefile.kvm
index ad9f9fa181a1..8e05cc8ec204 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -182,6 +182,7 @@ TEST_GEN_PROGS_arm64 +=3D arm64/vgic_group_iidr
 TEST_GEN_PROGS_arm64 +=3D arm64/vgic_group_v2
 TEST_GEN_PROGS_arm64 +=3D arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 +=3D arm64/no-vgic-v3
+TEST_GEN_PROGS_arm64 +=3D arm64/native_cache_config
 TEST_GEN_PROGS_arm64 +=3D arm64/idreg-idst
 TEST_GEN_PROGS_arm64 +=3D arm64/kvm-uuid
 TEST_GEN_PROGS_arm64 +=3D access_tracking_perf_test
diff --git a/tools/testing/selftests/kvm/arm64/native_cache_config.c b/tool=
s/testing/selftests/kvm/arm64/native_cache_config.c
new file mode 100644
index 000000000000..4afea32f2348
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/native_cache_config.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * native_cache_config.c - Test KVM_CAP_ARM_NATIVE_CACHE_CONFIG
+ *
+ * Verify that enabling the capability populates the vcpu's CLIDR_EL1
+ * with the real hardware value instead of the fabricated default.
+ */
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+
+#define CLIDR_EL1_REG_ID ARM64_SYS_REG(3, 1, 0, 0, 1)
+
+int main(int argc, char *argv[])
+{
+	struct kvm_enable_cap cap =3D {
+		.cap =3D KVM_CAP_ARM_NATIVE_CACHE_CONFIG,
+	};
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	uint64_t clidr_before, clidr_after;
+	int r;
+
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_NATIVE_CACHE_CONFIG));
+
+	vm =3D vm_create_with_one_vcpu(&vcpu, NULL);
+
+	/* Read the fabricated CLIDR_EL1 */
+	clidr_before =3D vcpu_get_reg(vcpu, CLIDR_EL1_REG_ID);
+
+	/* Enable native cache config */
+	r =3D __vcpu_ioctl(vcpu, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(!r, "KVM_ENABLE_CAP failed: %d (errno %d)", r, errno);
+
+	/* Read CLIDR_EL1 again */
+	clidr_after =3D vcpu_get_reg(vcpu, CLIDR_EL1_REG_ID);
+
+	pr_info("CLIDR_EL1 before: 0x%016lx\n", clidr_before);
+	pr_info("CLIDR_EL1 after:  0x%016lx\n", clidr_after);
+
+	TEST_ASSERT(clidr_after !=3D 0,
+		    "CLIDR_EL1 should not be zero after native config");
+
+	/* Invalid: non-zero args should fail */
+	cap.args[0] =3D 1;
+	r =3D __vcpu_ioctl(vcpu, KVM_ENABLE_CAP, &cap);
+	TEST_ASSERT(r =3D=3D -1 && errno =3D=3D EINVAL,
+		    "Non-zero args should fail: got %d errno %d", r, errno);
+
+	kvm_vm_free(vm);
+	return 0;
+}
--=20
2.43.0



--=-fUCIPL1EFDn51viUi3G3
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI2MDQwOTE1Mjkw
NlowLwYJKoZIhvcNAQkEMSIEIPrb4sAbwyGGmhl8RCmV91WUQVEXNPX7a4TNoYjFQgB0MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIASzmOmHGAMRP7
9n7AenkM+O+s/RYpGbb7rMpy3vbezprJ3C9xy4SNX4LZtqpE2ZJDa6uc22qaHNWSDDJj5Yaj9I8e
fOu5/PaENHMbhfLT+K/jFHrA3et/UAGj6+BtzhkDjkUq82hHAz/9qwZI7GhxcZ3oYOMdENMIXKeQ
zoUjT22E3DdLgU1lHvzo5KGE1s7CG22q/zDxbY9tRx5PoVKfkH9rRP7wov63BH08KdwxjYNV5Wu3
qrmGOLRA8ZWeZxKr7vm1ntL/OlVWV1LrJT4vCnt28Ekx3TU1ujGucNjbwkNInK6LnyJr7dRFtVz4
SmZ6ZOZI57HuXdgXjmUkzZ9p903+lycSj680jOz1uBxuK/vkKLnJDVJxR44WpB04gUUpMlzkyQkX
TwWJeSkwDwt6k93k/92f5RzrdQ8xYhTi3Ky0VYYC8QkH230Vve18vqxyyg5q1yl0QFJiIbFSQqz9
0iYkJu1r4VghT1HDRVcan4hO+5+BU9r1JMlV2Rt20tBMZzf9CxRikeiffdOWcO8Z1pYGCiPt+3UA
UTasQMnU/F9BleDKFuIDPJHotTcCpCulejb5i1R5TpgWRped6RYGGYIaCXj9EEe1pgSBowHFsyya
xSss0OPlAWZuEcP7ZE/4Nkv3cFPrV2hT4Gba+7l5DlpC3/xCwYDeZj3wm22pNYUAAAAAAAA=


--=-fUCIPL1EFDn51viUi3G3--
