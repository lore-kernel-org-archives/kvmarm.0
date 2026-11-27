Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.87
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795771357;
	b=cMPCvzOVENu5B/0GiZ1lV6S7lM/fdkLv5HvtI1vjPXLAgGlnIQOoqaugHnrSlHipZtcp
	 oXWDqNAt4YX77cNMbqyM86WEoOHz9sbuXQU2CRO4GB0I1hnr7+A4g9EZci/QZRBkolZ5P
	 AmryLTotmlwjHvmkeoycHTI3DCxvTM2HE+puYMVMbJI2qF1czypBrR9dv8Uwl7EvVQMEe
	 bbQIxpeUcIe4PaiyaX1/FUB0lV/buD89SahAZYyOe/Tr+9FGfO+QcKgcXNZN2tJQr1Usm
	 sD8Gm40h6tMIMNgM2O7qF2hogFOmpkGeimSymt+GmaacZw6Bl5gPj+tNW6RvUA2HxJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795771357;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=Xut3zz3zXoRLkxakwjQf3q4jqPlZOu+LVNDrD9v9huI=;
	b=Wdmvg8CQWtBrOugul9inO4t+4edoWKiseBb2ngzYPcGiIQ1sRTNjlI5QxWKuRnAZQgUQ
	 6mFCVzwUZyTnVMxJAQkGZOEgPeMAeX/+3PNw9JYw+m0WT9rNhRVEJyn7skEUABqf15wu2
	 +bycPsfo+zsGTBweZ70ufm3QuYBvPxgllvZc3yd44pq2rkpcPn3n7TURP06TuhG2pgDlR
	 DnlX+/bf8KL7JATl9/a+zDpG2Jx7076xc454ZzkniHoIhxu+p1OjmyT0aNoBzbga3NEOr
	 rsqoTmjuxxrOwEU0oeGYJjdoNm6AEjuqwt+Shz++NgQ0PsmxteXfIjG3zY3W3oR0W4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dzBSKDZJ;
	arc=none smtp.remote-ip=91.218.175.87
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0AD606A31C
	for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 09:22:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6E0AD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dzBSKDZJ
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=Xut3zz3zXoRLkxakwjQf3q4jqPlZOu+LVNDrD9v9huI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795771354; v=1; x=1796376154;
 b=dzBSKDZJB9QARKvRba6mZS+3IXZELdA4m2bLnDQ+f3NUKv9JsUS0d+n3aTkjsm66419Z7HlP
 ioaUdpghcDXIIZWOFoy1t/4nQy0PkgcDaKSuO/9b1f1kv1KPEbYlW+7nF2MuDDQUvJJbUN2jx0y
 jCehbkWfOwJ5pXSo+4OgjNFo=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3b2c99ac010040e6;
	Fri, 27 Nov 2026 09:22:34 +0000
X-Mizu-Trace-ID: 3b2c99ac010040e6
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5c14bc5a743so53758e87.0
        for <kvmarm@lists.linux.dev>; Fri, 27 Nov 2026 01:22:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHWA8/umOax4DEmUHwn2OTE0cu4wzpmF7mJ+BdprdqcU8/UllsVqNG02EWdW9mhqgpPgPR6FOE=@lists.linux.dev
X-Gm-Message-State: APuU4Z+czLl+rD9GcWKt2YMKE6JF8m7ylCv8smwLVdw1iXqclD2jujSA
	VKmlqsl/6PdfUF1v6f70/creAvyRmmbVA9xqfdwzZDLplUvWZXnaqIB6+EP2Q3UKu/Xajx3Z/1G
	Qy0VqwFoIU5oqIt+oFUMhwEG+PzZzRBWZTJbMzbFp
X-Received: by 2002:a05:6512:158d:b0:5c3:36c0:8a91 with SMTP id
 2adb3069b0e04-5c336c08cd3mr85482e87.7.1795771349523; Fri, 27 Nov 2026
 01:22:29 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com> <20261117174403.58762-22-vdonnefort@google.com>
 <CA+EHjTzZkAf8+BGNH15TKCEYUyO=VFvGSeJg5hfaFoefNOTVpg@mail.gmail.com>
 <awiQzMZxQDEHrRf4@google.com> <awlLEwegiWQZLeay@google.com>
In-Reply-To: <awlLEwegiWQZLeay@google.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 27 Nov 2026 09:21:53 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzPgQaZ=wwwK2CTyo-m85DdGX6AkfvYqhpBBOGGQ-Ct7w@mail.gmail.com>
X-Gm-Features: Aa3M54oiv4UO_oReuZkjeiZifggq1vhJlLPIvxDymRiZYopzsVCd9x47Vspkp8U
Message-ID: <CA+EHjTzPgQaZ=wwwK2CTyo-m85DdGX6AkfvYqhpBBOGGQ-Ct7w@mail.gmail.com>
Subject: Re: [PATCH v4 21/23] KVM: arm64: Add PKVM_HYP_REQ_SPLIT
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, 
	seiden@linux.ibm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, kernel-team@android.com, 
	qperret@google.com, weilin.chang@arm.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 27 Nov 2026 at 09:19, 'Vincent Donnefort' via kernel-team
<kernel-team@android.com> wrote:
[...]
> > > Could you drop nr_pages from the split request? Patch 22, the only place
> > > that raises it, passes 1, so this loop runs once.
> >
> > Hum, it is just we have range everywhere now so it feels a bit weird of not
> > having one here. But then I agree this isn't a stable API.
> >
> > --
> > Vincent
>
> Looking at the existing kvm_pgtable_stage2_split() interface, I see it does take
> a size as a parameter and so does its caller. So I wonder if it isn't better to
> align everything and to keep that nr_pages argument.
>
> However, setting nr_page=1 is indeed a bit weird. I believe the hypervisor
> should just emit a PMD-aligned request. I can also drop the loop iterating over
> nr_pages.

That's what I thought, that said, I have no strong opinion on this. I
promise not to relitigate this on the respin, regardless of what you
pick :)

Cheers,
/fuad
