Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793003198;
	b=A3eIex9UBAqnBX3Jgf1tanw2o/WfQ3umHKX15cnrDC+DjUQwtWSuAmSsTPfCnw3Z2LG5
	 ZHtcQc6E1HwwIU9xpPyPODSzCOA/8bTOGC1Lz1QpRdnYKonPtfGUyna/eNSzspdzz/PAl
	 2F1qemhUxNrC9JPJT8Wvk8sdiyQt03otJwk/xN4grlI/4HoII/TfTCY5ORkwu/cMAnoqs
	 F4GqqKmDmtntCSN4wQRxTMB7SYh4YihEItko+lpjmWZ/EoH7kePTDSnGvCirMYoMAML+r
	 M+R5ZmjK+ftDGM1+kOfF+L0iLG73p1FnRnIrxIIPBto5BmIvRdG5pAdqpHGFvdjcmGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793003198;
	h=Received:DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-SA-Exim-Connect-IP:
	 X-SA-Exim-Rcpt-To:X-SA-Exim-Mail-From:X-SA-Exim-Scanned;
	bh=lX8LvqZgD73olitS+s6RbnRC+ddhlxGmqCP4X38QoRU=;
	b=0ZmB88OyBU09mxzoxc7qJue3J7xBiHVbTeMLvNQdr/te2YfFAmHqUsk2JDng6mWceOYA
	 q3I/c+wAUHCalGoxsvyQiliXKHNuwIe8z8IAhPc/+lq2ZdcIgzkfkM2J9Wh+1d8MCA0K/
	 YQYtK4Jv6t7+FIqq/NYOqs6ESpluRDsvITzQQv1BzoWBCeU7kSnvZhb2xHVU+rS2RLT7S
	 xJo4ukY6QBqXdBPX2tyYoVPuIlghth7gJgr7M/81vLrccEz3vNAMU6hHxeqDyPtfq/s1u
	 Whv6FRk9IV7YJIPgEmpJ4xw33/iiBmmk+0euWPSDwUqkoGYW0QhP+zOE89v2FiN/W0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ah8C2fVP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FAF606A31A
	for <kvmarm@lists.linux.dev>; Mon, 26 Oct 2026 08:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ah8C2fVP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173A51F01825;
	Mon, 26 Oct 2026 08:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793003198;
	bh=lX8LvqZgD73olitS+s6RbnRC+ddhlxGmqCP4X38QoRU=;
	h=From:To:Cc:Subject:Date;
	b=Ah8C2fVPtUkaf6CPei2OZEo9J/LtAUIo8X85qe2mUFO1LTNqYbZP7DpeATekOtnXR
	 0i5MrNAEDMgbpm7aUutgTeSMVficL1pVmyjRlFlCuGC4oVwNlWlTkC0elwFh/Fyyuq
	 hI31dZ2A68oKZFEe4BWVzkSOyqaNWVhz5RjywWgKEln0OvCpCUD6NTswky3xVEV+K0
	 u5ozPjpYvOShe6Sez/0j+GneNiQ3a3JPsA40mNI4fMiHXzj6tkKe/mIa7IRLxwaVrx
	 gi5Z0XEWNeSuoiBQuEQe7gjzrYRaWFPyKD9o0yv0y/Oq8+xP5T7nxhjsa5Se8bXChd
	 aijqc3Vh4E2cA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1xLG2O-00000007A7G-1A1g;
	Mon, 26 Oct 2026 08:26:36 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Steffen Eiden <seiden@linux.ibm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH] KVM: arm64: Don't let a guest overwrite HCRX_EL2.MCE2
Date: Mon, 26 Oct 2026 08:26:33 +0000
Message-ID: <20261026082633.2515820-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, seiden@linux.ibm.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, fuad.tabba@linux.dev, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

FEAT_MOPS is fun. CPUs are allowed to implement any of two ways to
perform the memory copy, and the hypervisor is in charge of hiding
the difference between implementation when the vcpu migrates from
one to another. This is unhelpfully signalled with an exception,
which KVM diligently handles.

Today, we don't really make a good job of it in the sense that
if L1 also has the trap bit set, we don't forward the trap as
the architecture would require us to do.

But there is no good reason to forward this to the L1 guest if
L2 generates the "I'm on the wrong implementation". KVM can fix
it up in place and return to L2 directly, as if the physical CPU
was able to implement both options.

Conversely, allowing L1 to clear HCRX_EL2.MCE2 is counter-productive,
and violates the abstraction that KVM aims to give.

Implement this behaviour by never allowing the guest's view of
HCRX_EL2.MCE2 to make it into the HW, and document that KVM is in
charge of the A/B handling.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index a2a054fec2e2f..e18cf84a4993e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -330,7 +330,7 @@ static inline void __deactivate_traps_mpam(void)
  * Just like for HCR_EL2, we can't let the guest mess with some of the
  * basics we rely on in HCRX_EL2. However, the major difference is that
  * HCRX_EL2 only affects EL1, and never EL2 (sudden outburst of sanity, I
- * guess). So it is always the guest inflicting it on its own guestx.
+ * guess). So it is always the guest inflicting it on its own guest.
  *
  * Things we don't want to let the guest control are:
  *
@@ -339,10 +339,14 @@ static inline void __deactivate_traps_mpam(void)
  * - PTTWI: Similarly, it is for us to decide whether Reduced Coherency for
  *   the PTW is a thing. It really isn't.
  *
+ * - MCE2: FEAT_MOPS generated exceptions for Option-{A,B} interoperability
+ *   are always handled on the host and not forwarded to a guest hypervisor
+ *   in order to give the (poor) illusion of a homogeneous system.
+ *
  * - EnIDCP128: We don't allow IMPDEF sysregs -- full stop.
  */
 #define NV_HCRX_GUEST_EXCLUDE	(HCRX_EL2_TMEA	    | HCRX_EL2_PTTWI | \
-				 HCRX_EL2_EnIDCP128)
+				 HCRX_EL2_MCE2	    | HCRX_EL2_EnIDCP128)
 
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 {
-- 
2.47.3

