Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB9647DF98
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 13:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784812801; cv=pass; b=mOX5F+QSMunO+BuTyYNF3uCvqkfy2gGijUM0P37ZDOgJlGTymrzO5Yl1q6bfA7+iltf3irSUdNEW5V5Ah8unOifPqkMiHOvoE6LnpgLSR9eivc7GRAP7B3R9/2TnmI3EfmCD74R17FU1uK1PWyfBnaVRh16lEl78ZE1HH575lbk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784812801; c=relaxed/simple;
	bh=TliwDTVDhNVYMLlvKnPAH9MFniu3SJT7BxwLxOX+7YI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DOIdEpWyt3Y0EqFMcxTifGaBsTj30ZFs4hNpEbVLCoEbjrzHmTnLis6jxxEm3thd1GX14MbmdmdkfqrvXMc1y79K2O4MVu2q4dx8esFkZqV1mGZX+ZBHtVHQSzfUyL19eHQ6D5rzcnhZrdKg3coSm2k/LUVEqEamLklExRKiL6A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Tgt4ejSI; arc=pass smtp.client-ip=209.85.160.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Tgt4ejSI"
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c01c79467so258651cf.0
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 06:19:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784812791; cv=none;
        d=google.com; s=arc-20260327;
        b=IcIdQIBOBVfszH2MBxfMh6cRvmqobxGhr3L3J840vcHC7Siu81BEUEY74yLpLjB57M
         5+qWe96a1/ygz3aWlHJvZU9dNNICoCpFOoyegWLsSfj1C8Qo6jROnrfqSVQhBKLEwatH
         i5WkflOc0rzMvkj2LkSWpy7JKDZ1qEzqXqlIpEx0v3hRZfkrQV+ie51BL4eTPNCAH4R8
         aFeA4hOrYBkHCEGBy6k5MkC0IyfWZ6Rskcelm4HsrXI+WDreua1jCbY1lKXIxaxu8l32
         KFQEAXGlfWQ+7jzpcQjatit90hQnnQfkC+YWqi24SEssLCoXjweBfKOP/5KbEDTef1co
         jDMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Jlz4RirT2ApEMmnQX3AOsLAbmiz2q30wOmfHPI3CAeM=;
        fh=K53RjandeUdY4jAK0DnHncM495ldAvnF977RkfREYoE=;
        b=e95pH/z043g/ppB2b2eMnlAaBiHQIJF+58VUdm2viz7vs0OTVMM7ngYQLAtVWMu3OL
         9MfWG8Ksm+FV0r4eGghO71zVJJyOkx6cZRN1Et0vu+Mxl1ANVTFfbhhQh2Gp6gcYNXjo
         v7lGDnnVAIT8xZZF8tn58YJsDi0Taza/ZLWSsAHm1xLrxF5Mc+fMNW1tEXb7SkAcWBNm
         DvTwbuN1ffZr6vrMF3r8s1HJo3QUskLStS8Hk2NrPqvmFK56de4avDONQGGSM6DECzM+
         FCCW4VZ9Rwr5b3wMJ30T/5KBKnJBR4FVeXAAfDHoBbPCOgOzRoIIfN486N54DeWcG4UT
         KKhA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784812791; x=1785417591; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Jlz4RirT2ApEMmnQX3AOsLAbmiz2q30wOmfHPI3CAeM=;
        b=Tgt4ejSIiu15iXqI2YqFKrxtG1RAlDTkPvul1jqy4CHPc9bYwt9EL6gLwRqnZvZD5/
         a2rAsmlePZkhaCcnSeF29TKSuq2TOTxFOt1gz+8U/ltdNETStSfxv+QKVLKZcXXRucNY
         qsLafm3fsvhsKdqRjXFWjKf9QyKeJm6Cn1lknNOlO7o331S4S2XFEyGkKnjvybMBqt9Q
         6PVzNFU9QiIMicwhEfI+l9K4cOX7xGYVLEdVAKJ2LtHuM9DULkcvCKpPf0/c8vM7E8Vm
         3LUoUFXouCwirijsC//HON7EHMgALJb4PkvITSM7+WTwhdJGEgfnRRnbUHAYJLD/Sc+m
         slFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784812791; x=1785417591;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Jlz4RirT2ApEMmnQX3AOsLAbmiz2q30wOmfHPI3CAeM=;
        b=BQMNH3H1Tk0SG/Ikg8lKj0g47GFXK/832byyBe/pnNgM9fDpmf/CYJHP6y+xLF89BP
         V4HIb5r09YEQ/327am92GatB1z+L1++jkEx8pNNA2ELEzV1i9lpMuz9tvDQl/3CCpV58
         9ehUpx1ECm+1Twd10CHWuMzhzJe63U/5vpDY2XBlWyqT5Bw6yh6HQ8JzzKFa4GAkPQp9
         k2u54gm56gTiUc5v9ocbbV22faakkgkbkpMsxFpEdb9cs/Pm5FszHhiqqNk9Gm8ubbgw
         gg+YpgZwkUPaPG1CzhEHgGRAdj1FwnOxyO2ay+XuzlkLuGZZZK8KZaZIbe2YW11dYsLM
         hEMQ==
X-Forwarded-Encrypted: i=1; AHgh+RrIa8HWJgdSCphZ0BS+6+uLttIFiU1RMVUm7ZGKSDsVwMXPw1SvlMK4gymoNBKGHfxZoPXcKig=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1cmPVf8vaqz3AQu1r7ZjIHKQyswvPQPNyF90TMNuWr9dn0RG7
	Nj2a92SXPOM1T5X5Hy4vuv2ESPTFx3Brv5RhGVT/xAxg0HpVMTS97I2q+1LbW2s/BM1C2A10FI+
	TUw08oVGkmaMNmQTWNSwvWczAq/vtPtgzxjrfl5Nf
X-Gm-Gg: AR+sD11Wb6vBy+9X1u1HhXlyKIoEITSXSt/CTRSMjIHK5gYlzDOEJ725kQ8FP8nSZHa
	oz3SvpT4UBkhnDOJghkegye4voWg0OKPFCplgkiGLzRDtKuAWQMtnvgiquaEbl8+yaPsNH8rne0
	6rdOAlQVnyX4IArepb8lv2Zja4AfZr+c5uNeLn3bJpOMD61gX4HKjE+zeDk7Okd2TXlcD4+csCd
	Rv6vu344xmvPM+x5g7yuGDG7kW/u70wqb2dZmExa8eLAEM0PS9qWwkhYsu5Ug==
X-Received: by 2002:a05:622a:aa4d:20b0:517:38aa:c2b3 with SMTP id
 d75a77b69052e-5283bb02792mr9778161cf.14.1784812790765; Thu, 23 Jul 2026
 06:19:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com> <20260720171513.1415357-5-vdonnefort@google.com>
In-Reply-To: <20260720171513.1415357-5-vdonnefort@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jul 2026 14:19:00 +0100
X-Gm-Features: AUfX_mzXDP5kjyl7adkMau_slK5ytHRPwGWiWf56fyQqQaMq0ZgmYKXic-0afsY
Message-ID: <CA+EHjTwZftoD=D2G_1S271CPTdYhCcRwQGHYzwVS4OMLzAx-HA@mail.gmail.com>
Subject: Re: [PATCH v3 04/17] KVM: arm64: Add a heap allocator for the pKVM hyp
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

Hi Vincent,

On Mon, 20 Jul 2026 at 18:15, Vincent Donnefort <vdonnefort@google.com> wrote:

> +static unsigned long hyp_allocator_reclaimable(struct hyp_allocator *allocator)
> +{
> +       unsigned long reclaimable = 0;
> +       struct chunk_hdr *chunk;
> +
> +       guard(hyp_spinlock)(&allocator->lock);
> +
> +       chunk = allocator->head;
> +       while (chunk) {
> +               reclaimable += hyp_allocator_chunk_reclaimable(allocator, chunk, NULL, NULL);
> +               chunk = chunk_get_next(chunk);
> +       }

Sashiko raised this, again, confusingly in a different patch.
hyp_allocator_reclaimable() counts only the per-chunk reclaimable
pages, but hyp_allocator_reclaim() drains allocator->mc first, so the
memcache pages are reclaimable yet not counted here. When mc holds the
only free pages and there are no reclaimable chunks, this returns 0,
pkvm_shrinker_count() reports SHRINK_EMPTY, and scan() is never called
to free them. Should you add allocator->mc.nr_pages to the total?

Cheers,
/fuad
