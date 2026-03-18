Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8073B2FD9
	for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 16:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773850504; cv=pass; b=Fgslny8HZzSef34jAjHUbe8QwbyOFyV8hFo7QepSsZFxkPFKcv46AdpEIzx/DWLook0zjnc7Fid6EHT5p8HHuOSuo4pxuW0ivbwfsSBzMOzGuUf2pjBM2KRQaoNngYrs66kQcyvH4S0UDk0+nVPHhxhnWbLLy3In5C/vMXwTtDc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773850504; c=relaxed/simple;
	bh=lR0PJcfG1Y3m6nTSFCU7/TV+2TfIeopFlPfoOZ/YDtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f3+lk6HJ13gQZwg9HJ3g1BKmlES/YbA1gWmBnzcC55cFEz3fCrdhvEe0ca0MtgC4FLOh4zQwQuJ2k/O6i8gxDuPifZlvcqTNebih21QIv4kikUjfGshJqkC6vFVu3cDC+YWv9DoCXSOaf1hoNiW6y2e48c+4je1wHHAAKasveQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XWNhn/0+; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XWNhn/0+"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5091ed02c54so703731cf.1
        for <kvmarm@lists.linux.dev>; Wed, 18 Mar 2026 09:14:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773850499; cv=none;
        d=google.com; s=arc-20240605;
        b=Sc4m3l7JFoaK+LNEJLswGNsZnteXY3FPvsDAMsciGfksY248yJqYQWojI9uQTU8crD
         9bejr0FOv0mpirCQMbgG4Qa5iL/YXqsSz7uV1zGf2a+woQi+eIyTUCpOm2D6p4Bg13Se
         0DUrOQl98siOxtFzdmmxEMwYh384SSJIAyrt5ah6mqS2hNCLfouGhwkFyPuqGc4ARzUd
         qsdhrrD1hVU8vMncW91Q4mvYNcTvmtkvdEGcFILnAbDvcVWow6yPas4p2Qx8igF2qrwJ
         MCNZeC7x7i2tfKfUUxk4uu7w0Oq1fqz9gR1B/rGzupVdnf/9283Oq9faE7Kpjz2W2pfF
         +IRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=SsuRFxkPyyVGgkdo3YU+Oq4DrkAHZ3cwxEXT9hQFB6Y=;
        fh=ZfrVejHZ/eKQ8t5BzD5qDZ0aorYooyrzPR3JJsMCvQ8=;
        b=TLMAEoKuc0S2S//D6e7FR9oWxvDu7JsxWi5HAl2DvJAl5QsLT0iK0vgjL4yNeYNZ+9
         9ZrRWizMT61C1IP4BS5GnqiFRuCwLhLg+hxdt6U334QHO+lJKmCOsmCFuXZ5VthqjVlF
         VGmlx8ozeX/Pac2XKbZvYfDuxfUV7MpWThNZNSIX4dG0bpjtyDsRxaJZbs7jWGx3M34a
         DV6lmwJ6pCnPYeWXNpqQAimlPVH7B0FEOiUUI/i5ihIkc9acZfixJsHXdtACbUKjSK96
         Z6FPxQSRrxc7JqWT/YyUSVVcq/IUiJTsHHtKAZcNa0V5MlWG4cvhnEUYZX4S0Hy1bH17
         c+zQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773850499; x=1774455299; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SsuRFxkPyyVGgkdo3YU+Oq4DrkAHZ3cwxEXT9hQFB6Y=;
        b=XWNhn/0+R1ckwW4i4HpuwL5UOn/VMVylNaFCaeTw6Li4a+2vZ5lC3IiqSumY89ltYf
         Xm0hrfo7NIgwcKBKJ7l5vJXQtSoyGInT9ccGL220kksK3nFN38BOZG0PnVLW+7yeDGbZ
         mhgtb4qZSliDO2ciPaJODfBlNxQsVcyWgUIQTYds69cbqJ2jD3Tk+t/OGmDQkPwQzKGz
         EWDGeUcfrTHukr7nozAMpkdO6hriyMn+wx51jhb1EKi8zJlhv8iRMewfYSK4+t9UEajI
         nAkreI3u5icWnMd2MWtMw6rEM/MGX1ZBNqJrwiWSm7UOQTvzWuxn/eGmbnMmBMWvbi4C
         7qZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773850499; x=1774455299;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SsuRFxkPyyVGgkdo3YU+Oq4DrkAHZ3cwxEXT9hQFB6Y=;
        b=Gi5xsPdbKKY3Jh0+0EzQv3wr16w6rbngcF7ooMc0k9bTpLgMzpgh+09lVTzKM968x9
         k+3q7fq46kMC2CP2mx+AxRtLA2AfLaeOicxNduUhCOl3JeB2ix/9DMmssXlef359OfC+
         TqvSg7Wo7c7l6dcDv/BWKF+MVOMWMc84SSvfgJ1cTJeirwGARAhwg2oSkNvoy+zqlDk5
         BsjLLxNDyatYNd9+uVLAIsfMTMqw4Q0EUHasTxspIVbfWpBhuQ4bSpoQXO3f9BrbCpV+
         1Pgv0a4HAOJsedQnj24O+CIaW3OQjymTT5LtCjNXQU1ElBb3R6+IMC6IaXVM1nN4SO+X
         7Hmw==
X-Forwarded-Encrypted: i=1; AJvYcCVEltbjAUZ458Ew/XSUQ8ay94D8pjN8XbhXFQ3utGjVBBx/N4r61CyptiMTQi5HT/UsIz74d0c=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx29yqr4YeuJw1wNxVzxlTAZGXCWO+4IDLVPoNQbtd+BrwdYvSZ
	ZyQtN+wCNQzIGwMeQa6V2u0WW5MDDDkUd407m0Zp1N3EVWVBtFVm8/AuWOGb5Bo/gEEtxkAcvK1
	hEU841EweElAiFn/VJiLKKkaiJ7Uno5GEf27ZAQTc
X-Gm-Gg: ATEYQzxSbvSIx89WNAOCHfLmBoV3nSvkqkL1gph6+RdFM7npECIJlfP4e46+f10gSmC
	an+k/LmzC/O0GanJbKjPr86mo3aC08+8xzkyUYYBrHkI9eR/8yrzfM6v4XTpza11Iz86lu+wzdz
	1bX9CVuBg0cscer4m7Uo1fw90dE463bR+iUN4Nt7WGB1k8N7BtJpDkG2bcoNNoeFGIuEYmqszdn
	E4NZG0f7WfWPyGQPWe/xxkK2uFMtJoNE/fIzfLTR6zbgMkD7lITSSxIGZXiPpCkwOnHzSMznPlP
	8c6T5PWOvzEhH2slDgJ4LHOqOo9EvvX9aZJ6VA==
X-Received: by 2002:a05:622a:1ba1:b0:4ff:cb75:2a22 with SMTP id
 d75a77b69052e-50b15a39ceemr14465991cf.3.1773850498064; Wed, 18 Mar 2026
 09:14:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260316175451.1866175-1-maz@kernel.org> <20260316175451.1866175-10-maz@kernel.org>
 <20260318142215.GB3915656@e124191.cambridge.arm.com>
In-Reply-To: <20260318142215.GB3915656@e124191.cambridge.arm.com>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 18 Mar 2026 16:14:19 +0000
X-Gm-Features: AaiRm52R1KVo8O1bCSfrDTwrCK5ONNhPNzMB6IjRQpBSlu7SdfMD-LgrxUnYxG8
Message-ID: <CA+EHjTwbxTHr_fzSFD38cG4ZMj6XKr3L=o+=8T13XDQF0n6Raw@mail.gmail.com>
Subject: Re: [PATCH 09/17] KVM: arm64: Move VMA-related information to kvm_s2_fault_vma_info
To: Joey Gouly <joey.gouly@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Oliver Upton <oupton@kernel.org>, 
	Zenghui Yu <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>, 
	Quentin Perret <qperret@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Joey,

First, thanks for the reviews and the comments on my series. You're
right about my changes wrongly editing "page". I wanted it to be as
mechanical as possible to make it easy to review, but it ended up
being too mechanical.

<snip>

> > -     /* Mark the fault->page dirty only if the fault is handled successfully */
> > -     if (fault->writable && !ret)
> > -             mark_page_dirty_in_slot(kvm, s2fd->memslot, get_canonical_gfn(s2fd, fault));
> > +     /* Mark the page dirty only if the fault is handled successfully */
> > +     if (fault->writable && !ret) {
> > +             phys_addr_t ipa = gfn_to_gpa(get_canonical_gfn(s2fd, s2vi));
> > +             ipa &= ~(mapping_size - 1);
> > +             mark_page_dirty_in_slot(kvm, s2fd->memslot, gpa_to_gfn(ipa));
>
> I don't understand this change, why do we need to mask stuff now?

Let me see if _I_ understand it (Marc, please correct me if I'm wrong).

Before this patch, fault->gfn and fault->vma_pagesize were mutable,
and transparent_hugepage_adjust() modified both directly. In addition
to this being confusing (which gfn is this: the host /canonical or the
nested one?), it made it more difficult to separate the logic.

So, to mark a dirty page, it did this:
-             mark_page_dirty_in_slot(kvm, s2fd->memslot,
get_canonical_gfn(s2fd, fault));

which relied on the old struct fault to calculate the canonical gfn
using the (magically) THP adjusted fault->vma_pagesize.

Now that fault (or s2vi, its successor in this case) isn't mutable, we
need to get the canonical gfn using the host mapping size.

Cheers,
/fuad
