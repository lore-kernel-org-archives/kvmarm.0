Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D043CC9E4
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780648027; cv=none; b=XBEbijh0c0vQvG8DOY9e55+PhmaRkizRvmI1mRV3102+B9IYxdV8R/RrmbRO4fupkE66j5cHfpjdjyG2SteF1FSuNOqnpNGK6BS0GqD4bnjE+YW5Lxjav+N3tC+v8vEH0TTMDenSPtaMAyzA47ZrSKov8QUTjuVk/Eq2WmXH1Y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780648027; c=relaxed/simple;
	bh=CbJZfj0K13b53oFQ2rIEmq7riyTrXUgUz1lZrESkAyo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cqgYJ7ialge7Ktx+LL6fVm7jjLGYo6VIwG39YY0Y4HCm0MntHGAoUiwVAkvCR1mY9B/tITzXASLtvJKaq/Q00dlsAWPWW1cJU6Kte2pWGynKKLnl0RIbR3EUVCOlTzM60+sCyPFSlDIn1lqFvmK9fFBOARuxDNVERZpCz70sTXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ue6YxHlA; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ue6YxHlA"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-842848fd613so1259619b3a.3
        for <kvmarm@lists.linux.dev>; Fri, 05 Jun 2026 01:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780648025; x=1781252825; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=80P5JojD6lxQG8AaZDlXxzSX2ulhvqu/o5FnknnieX4=;
        b=Ue6YxHlAcvPmFFhSXUemrM8MjgWfIXs6OAXDl3DbmdVga0e+x5/5w6RapB7zHk81Sg
         46U3llcBQLOYuWw3XuCLLfg3CnypS1AxnoY5vf5iSfJFzg8nEw6BJt2a8hNOvnw2DEMr
         lRSIOEB9gg3wv8hRxdgXjaehmsX6zp8xT7VMXuWLsiYtrtRM2OBsvtBhP3do+lKlS1Vn
         GxViShcrGu3CPYjK9bCNng9tAOWWWcIxLUm8eoYdtv/tVgIXVnaLwAslJ6ttqn5BN4Yw
         qNoFUBAKHJipIu2XPTpsfJFezRSXYeCqh7iq5DS7iS6Fxcs6HmwXC6bHGas3wuZvHWlr
         cdkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780648025; x=1781252825;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=80P5JojD6lxQG8AaZDlXxzSX2ulhvqu/o5FnknnieX4=;
        b=EAOJCejZalvOcSECjRbv5uc/Nz0NTDH3RRaT6ePmv6m0qIEogi3pt2GHsVH/bIkGqV
         50v0wJeKWqGn6QoWaJjJzi2vDcyIuNnNXjZvlGpe3uFdo/oyqSIL7k2yRI218Wr8o+S4
         e8JqihHPxwwDUi1OjPskUgm3u8DJxdAtAieottHrWTsHanVt56TUwjFXLT5WsmSmCuwA
         QabQm+9MHth6Keh2qcBcjsxka+nE7clcYlv21uKchNS2KWFmft1ZqpJplgvq4qSAxpVq
         NlT57gXvz/VX7W+E5D/fhgHBfpubdH5G5x3LD35qyZp9kXMjR6Rf9wkDQomHcsksvwd6
         mDMg==
X-Forwarded-Encrypted: i=1; AFNElJ8w5ZoRu86cCvb1Nd0N97zxdUKaBOrYsUiXFtEQuXqwZVWfI87C5cA+bg8ZJVzVbZuI6nt3ptA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyjIqu7dbLrMdwxxnrEYGZt67BpZeLtGdjLpCY2fcBPyR+1YgGV
	2tScfcdygX63DKOREz0yXXwtcVhpwOapUjQnpABR+06va6pD+Vpdt0cG
X-Gm-Gg: Acq92OElmStqW0NNTHq2mOlbNYA6pVsKk6WmgXpUvdCB7FMgP6DtMbLL6F+9JFMNg8+
	NeYVj4AoWIMwWpHmItApxvOhZ5XmrdDFwYmsryGzYGAxwL3XiZpj4rztiTC+0nSouoF3yK5pE8h
	YitNGV00OsuWo0VSr+QrbiiEUa4bvesh2NHpQ0RW4Gy0he1ZhkDovXXzcEW3HubiRTzbpGWteFo
	a1GwvF06WE81c+0RX4f4FaGvRZvbkKAZjmr5Iyg/2secg8iQGJrWyel917det9Jv554HNWNJxdo
	RcvEYsJhm6FFMPkfSvF6qxtE4KV+b/WZiTWLUyIDWF5recDeWdS48EE4d1u9S+sOwQLeOyTsuOk
	E6SccKGHc5VDfped0Mi0dL1trOnw6VsgFjVLy6GUIhJjZD5A19poiu4PYeT6d8jotKLsd707P/i
	GQqfsYgRk7JyUZDxHc1bBlhTVCAY9iB5Pu+CdZAwpKZQT6cde87V8Fpme8CGGUiYyx
X-Received: by 2002:a05:6a00:bd13:b0:842:6a97:52f7 with SMTP id d2e1a72fcca58-842b0f1f25fmr2432559b3a.19.1780648025515;
        Fri, 05 Jun 2026 01:27:05 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-842828e02f9sm8388636b3a.48.2026.06.05.01.27.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 01:27:04 -0700 (PDT)
Date: Fri, 5 Jun 2026 17:27:01 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, christoffer.dall@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	imv4bel@gmail.com
Subject: [PATCH v2] KVM: arm64: Reassign nested_mmus array behind mmu_lock
Message-ID: <aiKIVVeIr1aAB1yp@v4bel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

kvm->arch.nested_mmus[] is walked under kvm->mmu_lock, including from the
MMU notifier path (kvm_unmap_gfn_range() -> kvm_nested_s2_unmap()), which
can run at any time. kvm_vcpu_init_nested() reallocates the array and frees
the old buffer while holding only kvm->arch.config_lock, so such a walker
can reference the freed array.

Allocate the new array outside of mmu_lock, as the allocation can sleep.
Under the lock, copy the existing entries, fix up the back pointers and
reassign the array. Free the old buffer after dropping the lock, as
kvfree() can sleep as well.

Fixes: 4f128f8e1aaac ("KVM: arm64: nv: Support multiple nested Stage-2 mmu structures")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Oliver Upton <oupton@kernel.org>
---
Changes in v2:
- reword shortlog and changelog per review 
  (diff unchanged; kept Oliver's Reviewed-by)
- v1: https://lore.kernel.org/all/aiHEKOeZMVwsRlvP@v4bel/
---
 arch/arm64/kvm/nested.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 38f672e94087..6f7bc9a9992e 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -89,21 +89,28 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	 * again, and there is no reason to affect the whole VM for this.
 	 */
 	num_mmus = atomic_read(&kvm->online_vcpus) * S2_MMU_PER_VCPU;
-	tmp = kvrealloc(kvm->arch.nested_mmus,
-			size_mul(sizeof(*kvm->arch.nested_mmus), num_mmus),
-			GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (!tmp)
-		return -ENOMEM;
 
-	swap(kvm->arch.nested_mmus, tmp);
+	if (num_mmus > kvm->arch.nested_mmus_size) {
+		tmp = kvcalloc(num_mmus, sizeof(*tmp), GFP_KERNEL_ACCOUNT);
+		if (!tmp)
+			return -ENOMEM;
 
-	/*
-	 * If we went through a realocation, adjust the MMU back-pointers in
-	 * the previously initialised kvm_pgtable structures.
-	 */
-	if (kvm->arch.nested_mmus != tmp)
-		for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
-			kvm->arch.nested_mmus[i].pgt->mmu = &kvm->arch.nested_mmus[i];
+		write_lock(&kvm->mmu_lock);
+
+		if (kvm->arch.nested_mmus_size) {
+			memcpy(tmp, kvm->arch.nested_mmus,
+			       size_mul(sizeof(*tmp), kvm->arch.nested_mmus_size));
+
+			for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
+				tmp[i].pgt->mmu = &tmp[i];
+		}
+
+		swap(kvm->arch.nested_mmus, tmp);
+
+		write_unlock(&kvm->mmu_lock);
+
+		kvfree(tmp);
+	}
 
 	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
 		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
-- 
2.43.0

