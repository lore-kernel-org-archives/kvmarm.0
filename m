Received: from mail-yx2-f43.google.com (mail-yx2-f43.google.com [74.125.224.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0EE44E675
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 19:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789933030; cv=none; b=ReAHBkMHOOmLY18PaqYmHmT55Wk2o97fQLD+1aTNrZstPPIvfXwhGuAt31j02Ef27LILsoprcYntqBfKXQbAA/Cwtir5F4njQZGQsstI+sO3An2QqtJjhCbhJ1hbH/pfQNefhTGwbj9n/BKnu1kmzu6pfuiAFz6j4H8c/sqLvco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789933030; c=relaxed/simple;
	bh=wQ3ou0OMG8Kvrev6k20Um/PDy/0+0e9DtH56kTKSrbo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RKJE8KK6IZp6gTi07jnKms5WiTwNOuQtZArUfIC5KuYMcN8xShIs/YUg2NftYh8W+z3E/6W0iu5q91BTsZqusgNZBjZ6i4e3hU/1C5ZskpCId5WF42sud0BFcIJ3AOLxFdcYJdJTwi8ubZkXSper1kW8ZpEPRaJa/LfOF2adGJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com; spf=pass smtp.mailfrom=soleen.com; dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b=R5rB73sz; arc=none smtp.client-ip=74.125.224.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=soleen.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=soleen.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=soleen.com header.i=@soleen.com header.b="R5rB73sz"
Received: by mail-yx2-f43.google.com with SMTP id 00721157ae682-85d4ddd179eso17249577b3.3
        for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 12:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933027; x=1790537827; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wVwJQFyVies0sN36ZwALD03xlxJgg7HjR5Oz9PMtlp0=;
        b=R5rB73szNmMkX4MeQpa5BcjEFiuYyM/+F8+wA+VoNjx68FsVx3/ZCQjrx2X86JgSGU
         SueHp+dpVgcgEAK6P3LhFGd/NuJClW0AVp4gPwz1NeuS4On7gtSBKMKWfHs9C+K7PFMx
         LbG8SQbmQ9MWiZh8WwCPD9mYQsI0/zcCO4fXCPXbn2BWfl9uavka6oQxxT/SkChQhmwl
         6Tv3Jf+5wPA/WqZU7lg311PUgtgwOwAOcqNzEIG0UtJLItNim1ZcfEIdWRN/Zg0HymrV
         fpe79Z3ZgbCybq84znKgJ70ent+RUZib4IlxUHW8X27AGc0mJajCedZGB2yAXCZcSaJJ
         q78Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933027; x=1790537827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wVwJQFyVies0sN36ZwALD03xlxJgg7HjR5Oz9PMtlp0=;
        b=vBzmHzwasvw8V4Pe9QZekhMSgmQygrdA+stnalfY2j5iuRzi9wEvSCEz6M/apmoavQ
         bhSZ+RgKxpemGuDAro57vcSHWBccmboyvK9QnFeVfOohTDouZ6Can9Bs6Sm9VaE8Yqzf
         9+hLecGRLuBY1YIhUIGBAzQazctuBWMriOCQnanjdM2taQCFs+6vLeWV7unKgF28hioh
         owVzXr3Z1EQ8SrTxUPnlDZ6H4YWX3ie+HQDNLYm3CSGj3MSq9C2fnXimi48OpFVvGNOq
         cwMisq28IEu6OaZicmn8FNd/Ru6RRrNgIiQZ8nQO9JPAnLgKLNeOTWwpkwbe9ccYnIJI
         cBEQ==
X-Forwarded-Encrypted: i=1; AKwUvByeKHQ/ZWNDcvdyhU83nDzenwx9FGuFTRqwOCvaCik15ZEk5f4iw7+Sskvny7kmbIpTo2DlaXw=@lists.linux.dev
X-Gm-Message-State: AFuF++n5J865IEGxEUdCSFSpUtyuMALR2HDote41dkQRrVx8ssAwvjB6
	fGP14Qx3r3Prlt5IP296aV2J7/pivY7Az/h7I68JljnfjqxB/tqcWcSCYnGqhynU2ho=
X-Gm-Gg: AYBFou2x9+yfNoGth78l5g2nQGX6yZ+q8VgsPCTNRvjPqcbSdiT69Gpd1UvbELbEngO
	RFMv6tdambNoZQGjY/9Ejplvdcj8k0Jn8pxu4Lu0SG4iZCg+Ur6gsTsp/Lzcc80P7Y6y0jdzoFY
	EfRdZrxXLHpgMD0tS8isL7qWQZE9j21s1qrZhtj85M/8ZR+wnNSRR7dOMgkoro6+9A4Z/9BXgPV
	AFbvc/Lz5mSZYUQGf1bFHZnsydDNhOnSjT1/8ZUCORZO98277Fha9A05FI9TafUMWmojhDl2LV3
	0idNBzfEEXJ1tHYyO2R54i0J/7UJpF32OqVI1aF13ZpWmjgRdi2sXPhGkGi+RABdKl/py5MYd5v
	LFkciqy6RghzH3gJDRPLFl0pC9OniBhyemKwvVHzD4JcYGlnb9bk+CDFMGAzKldfrrk6Z2gU65W
	xpas1eELdTOA2lkLVZ376vBLqgXajn8IQr/X3pBcaKLZGj5Kdz/0Y1+QkMzmhpzuo3m6tMKl8hf
	fCKts77Rt5jBXksXC4Uksrk/T5/8b3oXbcA5iCOls0OD0WTemSn4qE8CUDWiXjeuMc6ehWMYjiB
	lmRbc3j12upDWNp+jmc=
X-Received: by 2002:a05:690c:89:b0:89a:63da:cbe1 with SMTP id 00721157ae682-89a63dacc8fmr20430637b3.39.1789933027324;
        Sun, 20 Sep 2026 12:37:07 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a47139db2sm18450487b3.26.2026.09.20.12.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:37:06 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 02/46] KVM: arm64: Split demux_c15_{get,set}_val from userspace accessors
Date: Sun, 20 Sep 2026 15:36:06 -0400
Message-ID: <20260920193650.3373435-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Factor demux_c15_get_val() and demux_c15_set_val() out of demux_c15_get()
and demux_c15_set() so kernel callers can read and write demultiplexed
coprocessor registers without going through userspace pointers.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/kvm/sys_regs.c | 48 +++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d..b873ccf1ab14 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5496,10 +5496,9 @@ id_to_sys_reg_desc(struct kvm_vcpu *vcpu, u64 id,
 	return r;
 }
 
-static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
+static int demux_c15_get_val(struct kvm_vcpu *vcpu, u64 id, u32 *val)
 {
-	u32 val;
-	u32 __user *uval = uaddr;
+	u32 idx;
 
 	/* Fail if we have unknown bits set. */
 	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
@@ -5510,21 +5509,34 @@ static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 	case KVM_REG_ARM_DEMUX_ID_CCSIDR:
 		if (KVM_REG_SIZE(id) != 4)
 			return -ENOENT;
-		val = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
+		idx = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
 			>> KVM_REG_ARM_DEMUX_VAL_SHIFT;
-		if (val >= CSSELR_MAX)
+		if (idx >= CSSELR_MAX)
 			return -ENOENT;
 
-		return put_user(get_ccsidr(vcpu, val), uval);
+		*val = get_ccsidr(vcpu, idx);
+		return 0;
 	default:
 		return -ENOENT;
 	}
 }
 
-static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
+static int demux_c15_get(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 {
-	u32 val, newval;
 	u32 __user *uval = uaddr;
+	u32 val;
+	int ret;
+
+	ret = demux_c15_get_val(vcpu, id, &val);
+	if (!ret)
+		ret = put_user(val, uval);
+
+	return ret;
+}
+
+static int demux_c15_set_val(struct kvm_vcpu *vcpu, u64 id, u32 newval)
+{
+	u32 idx;
 
 	/* Fail if we have unknown bits set. */
 	if (id & ~(KVM_REG_ARCH_MASK|KVM_REG_SIZE_MASK|KVM_REG_ARM_COPROC_MASK
@@ -5535,20 +5547,28 @@ static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
 	case KVM_REG_ARM_DEMUX_ID_CCSIDR:
 		if (KVM_REG_SIZE(id) != 4)
 			return -ENOENT;
-		val = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
+		idx = (id & KVM_REG_ARM_DEMUX_VAL_MASK)
 			>> KVM_REG_ARM_DEMUX_VAL_SHIFT;
-		if (val >= CSSELR_MAX)
+		if (idx >= CSSELR_MAX)
 			return -ENOENT;
 
-		if (get_user(newval, uval))
-			return -EFAULT;
-
-		return set_ccsidr(vcpu, val, newval);
+		return set_ccsidr(vcpu, idx, newval);
 	default:
 		return -ENOENT;
 	}
 }
 
+static int demux_c15_set(struct kvm_vcpu *vcpu, u64 id, void __user *uaddr)
+{
+	u32 __user *uval = uaddr;
+	u32 newval;
+
+	if (get_user(newval, uval))
+		return -EFAULT;
+
+	return demux_c15_set_val(vcpu, id, newval);
+}
+
 static u64 kvm_one_reg_to_id(const struct kvm_one_reg *reg)
 {
 	switch(reg->id) {
-- 
2.55.0.1082.g2b9226bbc0-goog

