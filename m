Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F6C2D12F3
	for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823053; cv=pass; b=eOf9g+V32iG4Ie3cYHAbd2LtVlCh9ageiIppgbNM7fgRzNUcb+1aoWJ27FaPAaYT2+6fpHqXyVfe2i3aunCTQYUvi6/OjVp7QOmR1BePMMVOo0YCUiMU163aQ2kMIwRjTSNm/pq6sJg4hv9eyM21jor1k42lz9YykEYRi/YxlNI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823053; c=relaxed/simple;
	bh=ymTEtm1xUT2Zjm4lNdVflf1AsNNHImn2LhiZhw2y/1Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MSSSEgoa4QB1UPqH0dwbeusn6uonCk8nUDGUzJ7K29hY55RLiJVOd4EHExIy0YDAfMLQWDaCPKmJRw7biuUbKejYGJ+Gw0tSEHAVawT02UVGmR+SlDT8+f1RqZLNUmMek8PsbKDtsjhwMjeXiBRo1BemJh0V6YQruESRXNxJT8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=upeI2jQn; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="upeI2jQn"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c10ed63c0so272171cf.1
        for <kvmarm@lists.linux.dev>; Thu, 23 Jul 2026 09:10:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784823051; cv=none;
        d=google.com; s=arc-20260327;
        b=CqGOskf2TzhgrEdXB9N2CSTrIKEfzQITys537693KVjgI8J9UgWQH5yt70IgBZRGBY
         GIGpt+e8Kg3eXOZTFQhoeneOee51WK4f7rZ6I0Ox9+hlKf3ngobZxMVmGA+qpDqNH5/+
         mNIuqqZacgz74CMJPrwuZbqJVRRYlUs/kR7ZccCfnDLsgdiYybZY2Ec4D4CLA+wnuwa6
         EK6tHyQob+crs0aSl0dNmswrIiz0DFlObippnIFOw9f0I9ndHckyokSS0iWraBWacLDe
         ca6cXYNk1yir2ZWH7PoOkK9SHvLRc5sQIADUDofAtn3E719WXiRfTv5OAXUJ6CE7EWI7
         2hXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=U/e6OIrJ2NxawXYZpy8WiNSmx5lsziddODGJqeu5vuM=;
        fh=OjuQcRgvPI9Ly9H3XxQjvLoiXScnuQUAKKyBwkS441k=;
        b=VbD4h+SJr9tPv17cFwz6JxgMkGxl3DADidbA4UFdFj916XmlQnOW28PeQg0aca9rkA
         gI+Q+sZ4STIXZ/o0Bf7rBWWSuVlZhV3yjDwvhXxQr61SaBwOkVBZf1D8gVG8EyuVCER/
         4MRs08vvaIYU88YDegRkhrHvCfvz3gJU+WMatoqCPSQWV7XqZ+mkf2Ur2ZyumwHLRNiz
         S1D7S/AV6fPqWlQlnoLx4fLiTxR0q64E717eRH3trp4Mfr2g/wzLX+9CzxTxwRcOLrgq
         XhJp201xSo6HVzK2jXHxcKObBaYL5syuMy+Agmd8eRjLfwNvLwWPX39TLP0cah8SsUE2
         7G/g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784823051; x=1785427851; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U/e6OIrJ2NxawXYZpy8WiNSmx5lsziddODGJqeu5vuM=;
        b=upeI2jQnsMTABIPvOKj7lpc+sUBqQtb8zPivSaYs+0Qe9sONDBVHzsoz394JW7aHz4
         pZ9LQim8fYiX/BL82MmWpWkVR8T2jNGxUGdYNASlwivlHwXQCIEjBY6HnSxSnbiLI7/4
         BnzSIEZEGpxkXlg2e3HABVmcpvULvR01LU0o3pK8WrkKTvhDL78YDTnQ/A7c2fAA2co5
         Z6juSHSjTZIeylHTfcQvdAzfgrMKSfDuRqfpoZVPbDY7zuccDEORGVpV8Lm/0zkZCbEy
         JT39KvzvkNIaorjZLCOhe1yOVfppewiiIw0ZZEW9vEQxzNt3/yKVl2ZD4ylMh3mfc4zk
         0dXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784823051; x=1785427851;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=U/e6OIrJ2NxawXYZpy8WiNSmx5lsziddODGJqeu5vuM=;
        b=U7yKQejSCOFPhYP2M/yrYtgEtk1zpQTLW8ggzYFg6bQ0cAcgRmgotxla/XaD2iaVZ7
         ln+0l34PbQ1B2+CvR1re6rr4e0xQ0x7l/xDBOP4bUSDjBT36KMfiBByIioNwcOBuD2y/
         VCb5oezHw5QQ2ZQ8SxGZAhnOOiVyohd45+R49giaoyftqHcbyppknFnPaYfH1sbnKlEa
         B7vEY6QzO03a97AxyuaIEnJ/NXQBqXlF/Z+8E9kAzyMdy5by5vdFHg/hbv/Iyz9Ol8Il
         FgBgBwV7SgMnmcU7Bo4ccSkLCRPDg4tQ6L+VTI9MbkZhhYj6IWbqZBDx1rit6N+dv3PT
         8gXA==
X-Forwarded-Encrypted: i=1; AHgh+RpBTYBAPFFRYaq8gTINMsIChBdxkFrt4xQTP61KaLvzLVCsUD5vQZXdPw4wlFr7tMaDkNzuci0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4pHsyiPIeO0KKf0cVqOSkDExWnMzEwRoLjF4bs/PUG15SwKnO
	4FabR2qPYsTsul5iAVtKpu+kZZu7DgQ4J5FoxjduFxpJAz/r1XuokSjCuW6zlKXudWNKQ7KLTUz
	sYXIcgfOtSucJV1QUb6L42xqMf1POtU0XFq2jI2iY
X-Gm-Gg: AR+sD13p/ugVWkpUg7xLmY5eM1lQ9axWDXJSJxYN3hJtLG0uGA5o7n4K6gjBAfVqwUA
	7CTx44KZGwiOoqmfhAQ7MKQhgaflaR7iGr/IWCSMW7s8/oaSbknUyyWg4FINs2NDH2rargtzRvb
	gzSFXI3jhc2uvK5b338IcWXPgJmh0EYHKWCS/W5feN1hBZnfSTb91TI6y9lUhY/mwKTKH59tPEP
	D/nyctnaLNf1u+fswMsJIlkHJS3kOnaAmiJ3iAYZ8uTU3w9RN8aQm+lhzTBnw==
X-Received: by 2002:a05:622a:2506:b0:51c:ca9:3d15 with SMTP id
 d75a77b69052e-5283bb03cfdmr10935421cf.12.1784823050317; Thu, 23 Jul 2026
 09:10:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260720171513.1415357-1-vdonnefort@google.com>
 <20260720171513.1415357-14-vdonnefort@google.com> <CA+EHjTw7t6KHuQwktNN5_dJgZCxeWejcoQMz3pe6wUuS=R+QtQ@mail.gmail.com>
 <amIuh8OZk_xuk6_k@google.com>
In-Reply-To: <amIuh8OZk_xuk6_k@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 23 Jul 2026 17:10:13 +0100
X-Gm-Features: AUfX_myES7cc5zyhy84P3Ly98pOsyZv9KojYBrf3Vl-7ne9L08p9f-hLsZOxvLs
Message-ID: <CA+EHjTyc+qUHYkP8V4gquDn9uDJRxVnbZgr5ooj++68sEPkyFQ@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] KVM: arm64: Alloc pkvm_hyp_vm using pKVM heap allocator
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 23 Jul 2026 at 16:09, Vincent Donnefort <vdonnefort@google.com> wrote:
>
> On Thu, Jul 23, 2026 at 01:14:10PM +0100, Fuad Tabba wrote:
> > Hi Vincent,
> >
> > On Mon, 20 Jul 2026 at 18:15, Vincent Donnefort <vdonnefort@google.com> wrote:
> > ...
> >
> > > +static void errno_to_smccc(int ret, struct kvm_cpu_context *host_ctxt)
> > > +{
> > > +       struct pkvm_hyp_req req = { .type = PKVM_HYP_NO_REQ };
> > > +
> > > +       switch (ret) {
> > > +       case -ENOMEM:
> > > +               req.type = PKVM_HYP_REQ_HYP_ALLOC;
> > > +               req.mem.nr_pages = hyp_alloc_topup_needed();
> > > +               break;
> > > +       }
> >
> > Sashiko raised this in a different patch. This turns any -ENOMEM into
> > a top-up request, but hyp_allocator_map() also returns -ENOMEM from
> > the pkvm_map_private_va_range() failure path without setting
> > topup_needed, so nr_pages can be 0. The host then handles a 0-page
> > top-up and the while (!__ret) loop in pkvm_call_hyp_req() just
> > re-issues the same failing hypercall.
> >
> > This might not be reachable today, but could you make it so that
> > errno_to_smccc() raises the request only when nr_pages is non-zero,
> > and let -ENOMEM propagate otherwise?
>
> I could also introduce a HYP_ALLOC specific ENOMEM?
>
> Otherwise, yes checking on hyp_alloc_topup_needed() sounds alright.

No strong opinion, but it seems to me that checking on
hyp_alloc_topup_needed() is simpler and safer. That said, if you have
reason to do it differently I don't mind.

/fuad

>
> >
> > Cheers,
> > /fuad
