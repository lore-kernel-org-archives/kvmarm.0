Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0117D9440
	for <kvmarm@lists.linux.dev>; Thu, 30 Mar 2023 17:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA970C433D2;
	Thu, 30 Mar 2023 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1680198980;
	bh=j4JO11VWdwqIaKF8c/g79EFYH8oZhijnY47fSUcGskA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UxPL+jHGlvn9HsYccr8vuK6mT/3+XKZhO/ajEA6x96ZofI6jsFs10GbPT2SezsnwD
	 Gfyers1CUBsJVgyZxyAz+swcT8QIGjt0whljiBR/ZngKu/pODIcLdvBUgggYOeqMHH
	 NucaEb1xdKYK9/vOjp55IhG3P9xTHHJz3aWH7I7jpAz9D+H6s8dEtwRifZjTGWjzQa
	 scfidxA4ICA7S63SCWQDiAtoJAzvaTm/UomXURNbEbjlysWURNdHR99qUR9+jViyF/
	 q9S68W0So48VDS8MzAY4VPRrz8oYNN3bt30Rw1UD6+KzQKnzqh+viAKbMHHd+47HOf
	 GX7KLtv2+wYCA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1phwNc-004Rpa-Fz;
	Thu, 30 Mar 2023 18:48:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ricardo Koller <ricarkol@google.com>,
	Simon Veith <sveith@amazon.de>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	dwmw2@infradead.org
Subject: [PATCH v4 18/20] KVM: arm64: selftests: Add physical timer registers to the sysreg list
Date: Thu, 30 Mar 2023 18:47:58 +0100
Message-Id: <20230330174800.2677007-19-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230330174800.2677007-1-maz@kernel.org>
References: <20230330174800.2677007-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de, reijiw@google.com, coltonlewis@google.com, joey.gouly@arm.com, dwmw2@infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that KVM exposes CNTPCT_EL0, CNTP_CTL_EL0 and CNT_CVAL_EL0 to
userspace, add them to the get-reg-list selftest.

Reviewed-by: Colton Lewis <coltonlewis@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 tools/testing/selftests/kvm/aarch64/get-reg-list.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/get-reg-list.c b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
index d287dd2cac0a..1b976b333d2c 100644
--- a/tools/testing/selftests/kvm/aarch64/get-reg-list.c
+++ b/tools/testing/selftests/kvm/aarch64/get-reg-list.c
@@ -651,7 +651,7 @@ int main(int ac, char **av)
  * The current blessed list was primed with the output of kernel version
  * v4.15 with --core-reg-fixup and then later updated with new registers.
  *
- * The blessed list is up to date with kernel version v5.13-rc3
+ * The blessed list is up to date with kernel version v6.4 (or so we hope)
  */
 static __u64 base_regs[] = {
 	KVM_REG_ARM64 | KVM_REG_SIZE_U64 | KVM_REG_ARM_CORE | KVM_REG_ARM_CORE_REG(regs.regs[0]),
@@ -858,6 +858,9 @@ static __u64 base_regs[] = {
 	ARM64_SYS_REG(3, 2, 0, 0, 0),	/* CSSELR_EL1 */
 	ARM64_SYS_REG(3, 3, 13, 0, 2),	/* TPIDR_EL0 */
 	ARM64_SYS_REG(3, 3, 13, 0, 3),	/* TPIDRRO_EL0 */
+	ARM64_SYS_REG(3, 3, 14, 0, 1),	/* CNTPCT_EL0 */
+	ARM64_SYS_REG(3, 3, 14, 2, 1),	/* CNTP_CTL_EL0 */
+	ARM64_SYS_REG(3, 3, 14, 2, 2),	/* CNTP_CVAL_EL0 */
 	ARM64_SYS_REG(3, 4, 3, 0, 0),	/* DACR32_EL2 */
 	ARM64_SYS_REG(3, 4, 5, 0, 1),	/* IFSR32_EL2 */
 	ARM64_SYS_REG(3, 4, 5, 3, 0),	/* FPEXC32_EL2 */
-- 
2.34.1

