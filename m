From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v2 23/23] KVM: arm64/sve: Document KVM API extensions for
 SVE
Date: Fri, 28 Sep 2018 14:39:27 +0100
Message-ID: <1538141967-15375-24-git-send-email-Dave.Martin@arm.com>
References: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AF1DB4A26A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:41:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dqj3Xf6yn4FO for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Sep 2018 09:41:04 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 404914A1E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Sep 2018 09:41:01 -0400 (EDT)
In-Reply-To: <1538141967-15375-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adds sections to the KVM API documentation describing
the extensions for supporting the Scalable Vector Extension (SVE)
in guests.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 Documentation/virtual/kvm/api.txt | 142 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 139 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index a58067b..b8257d4 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2054,13 +2054,21 @@ Specifically:
   0x6030 0000 0010 004c SPSR_UND    64  spsr[KVM_SPSR_UND]
   0x6030 0000 0010 004e SPSR_IRQ    64  spsr[KVM_SPSR_IRQ]
   0x6060 0000 0010 0050 SPSR_FIQ    64  spsr[KVM_SPSR_FIQ]
-  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]
-  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]
+  0x6040 0000 0010 0054 V0         128  fp_regs.vregs[0]    (*)
+  0x6040 0000 0010 0058 V1         128  fp_regs.vregs[1]    (*)
     ...
-  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]
+  0x6040 0000 0010 00d0 V31        128  fp_regs.vregs[31]   (*)
   0x6020 0000 0010 00d4 FPSR        32  fp_regs.fpsr
   0x6020 0000 0010 00d5 FPCR        32  fp_regs.fpcr
 
+(*) These encodings are not accepted for SVE-enabled vcpus.  See
+    KVM_ARM_SVE_CONFIG for details of how SVE support is configured for
+    a vcpu.
+
+    The equivalent register content can be accessed via bits [2047:0] of
+    the corresponding SVE Zn registers instead for vcpus that have SVE
+    enabled (see below).
+
 arm64 CCSIDR registers are demultiplexed by CSSELR value:
   0x6020 0000 0011 00 <csselr:8>
 
@@ -2070,6 +2078,14 @@ arm64 system registers have the following id bit patterns:
 arm64 firmware pseudo-registers have the following bit pattern:
   0x6030 0000 0014 <regno:16>
 
+arm64 SVE registers have the following bit patterns:
+  0x6080 0000 0015 00 <n:5> <slice:5>   Zn bits[2048*slice + 2047 : 2048*slice]
+  0x6050 0000 0015 04 <n:4> <slice:5>   Pn bits[256*slice + 255 : 256*slice]
+  0x6050 0000 0015 060 <slice:5>        FFR bits[256*slice + 255 : 256*slice]
+
+  These registers are only accessible on SVE-enabled vcpus.  See
+  KVM_ARM_SVE_CONFIG for details.
+
 
 MIPS registers are mapped using the lower 32 bits.  The upper 16 of that is
 the register group type:
@@ -3700,6 +3716,126 @@ Returns: 0 on success, -1 on error
 This copies the vcpu's kvm_nested_state struct from userspace to the kernel.  For
 the definition of struct kvm_nested_state, see KVM_GET_NESTED_STATE.
 
+4.116 KVM_ARM_SVE_CONFIG
+
+Capability: KVM_CAP_ARM_SVE
+Architectures: arm64
+Type: vm and vcpu ioctl
+Parameters: struct kvm_sve_vls (in/out)
+Returns: 0 on success
+Errors:
+  EINVAL:    Unrecognised subcommand or bad arguments
+  EBADFD:    vcpu in wrong state for request
+             (KVM_ARM_SVE_CONFIG_SET, KVM_ARM_SVE_CONFIG_SET)
+  ENOMEM:    Out of memory
+  EFAULT:    Bad user address
+
+struct kvm_sve_vls {
+	__u16 cmd;
+	__u16 max_vq;
+	__u16 _reserved[2];
+	__u64 required_vqs[8];
+};
+
+General:
+
+cmd: This ioctl supports a few different subcommands, selected by the
+value of cmd (described in detail in the following sections).
+
+_reserved[]: these fields may be meaningful to later kernels.  For
+forward compatibility, they must be zeroed before invoking this ioctl
+for the first time on a given struct kvm_sve_vls object.  (So, memset()
+it to zero before first use, or allocate with calloc() for example.)
+
+max_vq, required_vqs[]: encode a set of SVE vector lengths.  The set is
+encoded as follows:
+
+If (a * 64 + b + 1) <= max_vq, then the bit represented by
+
+    required_vqs[a] & ((__u64)1 << b)
+
+(where a is in the range 0..7 and b is in the range 0..63)
+indicates that the vector length (a * 64 + b + 1) * 128 bits is
+supported (KVM_ARM_SVE_CONFIG_QUERY, KVM_ARM_SVE_CONFIG_GET) or required
+(KVM_ARM_SVE_CONFIG_SET).
+
+If (a * 64 + b + 1) > max_vq, then the vector length
+(a * 64 + b + 1) * 128 bits is unsupported or prohibited respectively.
+In other words, only the first max_vq bits in required_vqs[] are
+significant; remaining bits are implicitly treated as if they were zero.
+
+max_vq must be in the range SVE_VQ_MIN (1) to SVE_VQ_MAX (512).
+
+See Documentation/arm64/sve.txt for an explanation of vector lengths and
+the meaning associated with "VQ".
+
+Subcommands:
+
+/* values for cmd: */
+#define KVM_ARM_SVE_CONFIG_QUERY	0 /* query what the host can support */
+#define KVM_ARM_SVE_CONFIG_SET		1 /* enable SVE for vcpu and set VLs */
+#define KVM_ARM_SVE_CONFIG_GET		2 /* read the set of VLs for a vcpu */
+
+Subcommand details:
+
+4.116.1 KVM_ARM_SVE_CONFIG_QUERY
+Type: vm and vcpu
+
+Retrieve the full set of SVE vector lengths available for use by KVM
+guests on this host.  The result is independent of which vcpu this
+command is invoked on.  As a convenience, it may also be invoked on a
+vm file descriptor, eliminating the need to create a vcpu first.
+
+4.116.2 KVM_ARM_SVE_CONFIG_SET
+Type: vcpu only
+
+Enables SVE for the vcpu and sets the set of SVE vector lengths that
+will be visible to the guest.
+
+This is the only way to enable SVE for a vcpu: if this command is not
+invoked for a vcpu then SVE will not be available to the guest on this
+vcpu.
+
+This subcommand is only permitted once per vcpu, before KVM_RUN has been
+invoked for the vcpu for the first time.  Otherwise, the command fails
+with -EBADFD and the state of the vcpu is not modified.
+
+In typical use, the user should call KVM_ARM_SVE_CONFIG_QUERY first to
+populate a struct kvm_sve_vls with the full set of vector lengths
+available on the host, then set cmd = KVM_ARM_SVE_CONFIG_SET and
+re-issue the KVM_ARM_SVE_CONFIG ioctl on the desired vcpu.  This will
+configure the best set of vector lengths available.  When following this
+approach, the maximum available vector length can also be restricted by
+reducing the value of max_vq before invoking KVM_ARM_SVE_CONFIG_SET.
+
+Every requested vector length in the struct kvm_sve_vls argument must be
+supported by the hardware.  In addition, except for vector lengths
+greater than the maximum requested vector length, every vector length
+not requested must *not* be supported by the hardware.  (The latter
+restriction may be relaxed in the future.)  If the requested set of
+vector lengths is not supportable, the command fails with -EINVAL and
+the state of the vcpu is not modified.
+
+Different vcpus of a vm may be configured with different sets of vector
+lengths.  Equally, some vcpus may have SVE enabled and some not.
+However, such configurations are not recommended except for testing and
+experimentation purposes.  Architecturally compliant guest OSes will
+work, but may or may not make effective use of the resulting
+configuration.
+
+After a successful KVM_ARM_SVE_CONFIG_SET, KVM_ARM_SVE_CONFIG_GET can be
+used to retrieve the configured set of vector lengths.
+
+4.116.3 KVM_ARM_SVE_CONFIG_GET
+Type: vcpu only
+
+This subcommand returns the set of vector lengths enabled for the vcpu.
+SVE must have been enabled and configured for this vcpu by a successful
+prior KVM_ARM_SVE_CONFIG_SET call.  Otherwise, -EBADFD is returned.
+
+The state of the vcpu is unchanged.
+
+
 5. The kvm_run structure
 ------------------------
 
-- 
2.1.4
