Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B111F9A85;
	Tue, 25 Mar 2025 18:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928583; cv=none; b=EHhbErSxwFRkAOdMxtocExroc0HQmuyKWvQk4nBdWEZjSBIyKclJcqrbhxPK9Z3N5hPLriYiW1azjJ9h6A3pT5GWy6q7cmIqWtA9bJUhRhAdszUvKTi8hVW7wy2H99+x9jUorAhPsR7vYrJSD2PU+UdoYWE4FI7Yod2J82EDVUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928583; c=relaxed/simple;
	bh=ONHqmQTU63FaZh8cGmEzfPnyfUbijj0z1ke0L3d5q0w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kCrIBAudkrXUry/lrxdZoxDwf4YYwpTgiCklmBLhRj5Ea4mPHPpuBIqSiP1U3xaGFE9z40ED/IKlzHskWlIbDtEEC5RTCQZe7eWyPGY+5yrbM3P+Uc5FEllcEjMJM1sYnavwHAqzmCA8BfWEWOSfZoaBjOm18KPoSf1e3eC5WbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTf6miup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTf6miup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C8DC4CEEE;
	Tue, 25 Mar 2025 18:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928582;
	bh=ONHqmQTU63FaZh8cGmEzfPnyfUbijj0z1ke0L3d5q0w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LTf6miupkjPl9N8anUfRgeP1Co/m1rVJyTHgcNuaKPn9XRQPnuaMpI+DghKYakrBR
	 VLOH/cDJkoUCKfDYpvlL3vNm4dhMXeOhch51IpTdIRDnvnOSwEJ8zkPeBmIdMWvl4S
	 hrz3twYL0p7mSUpfTqrrW0tsvKM4MkK2d+gIveLI389Rvke60dhqdnO+ozLOgmAtLI
	 6XWINOskoa+SUhuLQUTIMyvlcLvUrij44KAKCwccmWsJQO9pmctUIkva3lR55dBxYC
	 /zBj79J7W/P/JPU0XPaJJSyI2xx/KKP80OCm+IAwArmAkcimbj7XizuetS3kkEnW9o
	 27/Pk0aUJDJ4w==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 25 Mar 2025 18:48:20 +0000
Subject: [PATCH 6.1 06/12] KVM: arm64: Remove host FPSIMD saving for
 non-protected KVM
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250325-stable-sve-6-1-v1-6-83259d427d84@kernel.org>
References: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
In-Reply-To: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Fuad Tabba <tabba@google.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3205; i=broonie@kernel.org;
 h=from:subject:message-id; bh=0NzIpXAxU01MpifJfCvdhXaQGfCJ7I1Q/ycBr5g/AJY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn4vqq7qRv8/r/FdSc2iFgMkvOxm6CFV9MTjPLsOKV
 G6zh3WKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+L6qgAKCRAk1otyXVSH0KdBB/
 0ZzAF42xKYF0NWGIgB42sAXL1YAERJx8UfWGp0/wIsQh3KyZL1QkVQe0UigkQssVf52jS7YgBrAIIb
 zl7fm51J0KTiITQ6LSxs4FIOjbtCtwTt0U1zx0/CCB0qT2DlhIwIOQefejiQ5ECd0673U+N+7wfRTH
 v4wpG60OhA5jLFAYDndbgZ1JR5OGKDtKO99M/tizpkcA/fxKIepfusy0u9hMsPC1UcCSW5fiqtxkgT
 Jsqgf2RTzxIiPNvWr2gYzqS2sGoIP1PE38G7qtNc4QRD4/TOHR26cWR5VFwbh5OjKz17BPp21CiYkn
 s2pf+0zcPpdJ8eU8hceTxGhM0h2Ci7
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 8eca7f6d5100b6997df4f532090bc3f7e0203bef ]

Now that the host eagerly saves its own FPSIMD/SVE/SME state,
non-protected KVM never needs to save the host FPSIMD/SVE/SME state,
and the code to do this is never used. Protected KVM still needs to
save/restore the host FPSIMD/SVE state to avoid leaking guest state to
the host (and to avoid revealing to the host whether the guest used
FPSIMD/SVE/SME), and that code needs to be retained.

Remove the unused code and data structures.

To avoid the need for a stub copy of kvm_hyp_save_fpsimd_host() in the
VHE hyp code, the nVHE/hVHE version is moved into the shared switch
header, where it is only invoked when KVM is in protected mode.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Mark Brown <broonie@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Link: https://lore.kernel.org/r/20250210195226.1215254-3-mark.rutland@arm.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 1 -
 arch/arm64/kvm/fpsimd.c                 | 2 --
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ----
 3 files changed, 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0e9b093adc6726770e0ff701ae9441ab31e448a5..7f187ac24e5d37369ef0af4154fdb17890f28798 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -380,7 +380,6 @@ struct kvm_vcpu_arch {
 	struct kvm_guest_debug_arch vcpu_debug_state;
 	struct kvm_guest_debug_arch external_debug_state;
 
-	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 	struct task_struct *parent_task;
 
 	struct {
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 1765f723afd493255010c71d9bd4a2ddef819565..ee7c59f96451fcb217957c9fdbbd76046393bef3 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -49,8 +49,6 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	vcpu->arch.host_fpsimd_state = kern_hyp_va(fpsimd);
-
 	/*
 	 * We need to keep current's task_struct pinned until its data has been
 	 * unshared with the hypervisor to make sure it is not re-used by the
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 081aca8f432ef3ee303feb437a9556a0e917d6c1..50e6f3fcc27cd35822246144c1e5f7761e316746 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -207,10 +207,6 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	}
 	isb();
 
-	/* Write out the host state if it's in the registers */
-	if (vcpu->arch.fp_state == FP_STATE_HOST_OWNED)
-		__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
-
 	/* Restore the guest state */
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);

-- 
2.39.5

