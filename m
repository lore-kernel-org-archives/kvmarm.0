Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652D7377034
	for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 09:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787217120; cv=pass; b=FhgioeWpjcITMd3Xs+0tHgcDsdVB9lZ3nKF4ZTGMEJijufWnORFd4fx16LpmoZ1odpv9buRO3X8B+Cf8btRSFPt/TMEWHUAeUBtkv6W5cGiLHijjW1jb+9gYSDjtL3G4V/tC4D23azL4z70BYvQLdSZUkT/1qETwO5BqyXZd8h4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787217120; c=relaxed/simple;
	bh=2ZeMm8DE2O/5B0Bj4WZre28WSgQ7huhL/ha2kx6VGbA=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s6Ogwamchiz3MMVweq3zCCKNsUae7Z9RMf6MvvcrjSNLO87C7eFt96I8hHQLPnQdbWUk7p7umL3nezhebZiG4yUzqUAPBC2yWv8epcuno8Ww+nItN7gR7YD9qzvwJhDrK+jkbn/u3CDG43Mcd8hZFJpXMY7SF3WAvARnQ60i7Og=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AexL6MTm; arc=pass smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AexL6MTm"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-9061a795d76so23526836d6.3
        for <kvmarm@lists.linux.dev>; Thu, 20 Aug 2026 02:11:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787217118; cv=none;
        d=google.com; s=arc-20260327;
        b=eTsTMt1P8snxC2oR6zuJzW6xsndYTHMuxiaEUpOKSc1eaCXb+PvQbmKHtfMUvgeJGu
         lDalRn1Sy4njjETtjuX6zAv855v4ZE9s5j8gQzU7m4RQ1Qbt+GmX46Qdcj60Ipf1L41W
         nYTxzZCm6qbNG+fV6nRgShNfjwzdKRCvq8Ca+3LHG5J6alA+CBAZYkdrBRmgefu1GSwM
         6myHz1wn06lUfqbg4pnYFrHVCU/0owVGweDQcLVLorpqNuf98nLMSszr9TqED4v4yRS6
         YAJPZL03IkIeEfv/u+tZNkYIf3xtrUF/YjPbAnOq+UWbeAPKOpjWKVFBSwWvDW3EQLLY
         ukHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date
         :mime-version:references:in-reply-to:from:dkim-signature;
        bh=T86+N4faSKKA7N1eC4Sy9A/XUrNm+NJ7hqhkZ646NMA=;
        fh=ItruS/Qf2ffeBnaZvR0L3i7PnFWi//HkPQcP068REWU=;
        b=KdbaC2YoMX6lR3Qz+LNA7RJtmPDVzq0s8x59LGNfKPNXWshWxd/qgXPbS9JzfxkIvh
         GV7c23nPK/p66JL2OFv9pLjl7lAqH/LhWb51HcYKFrdAECVDePWkF1xi3dDP+QHFJfsG
         igTqm7IFvajCpOQYiM1XvyQmOn6SDpqwwKcklVUZFOKokEvSZFZVmJQVgupKCBzN3MVi
         ivgmjPNpEpFCyAecaLJRX0Lmfw/MjMbN32W6ANHzV2JQ/Q2F+0+Wq/vHDPzgKpfiuaXr
         njkkZaT60NMEE8tSxALrA2hfjGEpfwC38GwKzq1kIFegwZ+q4U8ism02SYXFkMIgMOAY
         mYFA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787217118; x=1787821918; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=T86+N4faSKKA7N1eC4Sy9A/XUrNm+NJ7hqhkZ646NMA=;
        b=AexL6MTmHTOSjnW1KkKbbQeE468AkngFmqUcGbG5dxdc1PQHlxSax7vWqdKxVbmJsJ
         YMX5jblsymQ82/Qg+Qg/mQ2Eud2LXkWPzVufikDlP665qhJWlBwy341qTdz9Ds/7pktO
         /W+LTGfTlwjo2tyCMUMT3GTUnxKq4imC+bE79HAD93NnsCCWAu+8bmGba0QGNDzirX/z
         Sudje4wLk6V7LNTSVc2xLm30iVOAOPBqgrnkNW9SwgUvIRsZ8RLHnl1OHR1pB1xU7FhD
         IqSA9SquhLvpQL+HZ6mSPinZPkJd+mLPJkjeccyDPsYC4CLh+S2xUN68jnkDdRJiyNd6
         v9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787217118; x=1787821918;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:mime-version:references:in-reply-to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=T86+N4faSKKA7N1eC4Sy9A/XUrNm+NJ7hqhkZ646NMA=;
        b=OXPJCXrL3szP7eSNbuDtcjmzz2ivvCkPYr7CHGkUUHsFFtStUk70oyteCoVFijMsWw
         +AxZh13QKQOmLzP5bDyf7qWv2wraXKQ23lZduTE+0jey++A6O5HCyNz/apXweG/fWoUI
         9FFhwWh7X3wrqjWSoo7O5kNgKitLBRlmX8jvtYiqb3y9a69v9aCwkfTWqSDoIrk7+T1/
         JGecziC407qNqwcaf4et7sqoK0XDgNSl1LzBQcpFThbiaCe3vrfdnxfkoTl67/gazBEy
         qufFLY+CwrQ/EBeOQV9XrSS/mpB4Q4EXOWbPisn9L45s0Jn2pd6ybkhXtbkjMpVFuMBI
         cwuA==
X-Gm-Message-State: AFuF++kSUhd08TB3Iu2L9qC+i0E+c5AIaMfaJtzy5ZTS+s03q8Qbsb2k
	8akHq2g8So9Grj9XUu0222kO7bYXSZgo3FH6e0lIUQEicSyg3GEsvqWG7BP8gp/bKWCNv0DJuNZ
	t/7r0zLq2c+G+H3xQBfjPjfT8FohMryDntKSjnBG+
X-Gm-Gg: AR+sD10S5WAyoUZNLDsXtSwLjS+K1xgL7FHzKglfvay6qkj4KN/T/CFU6HklVH0I2Si
	J+qHVffliSP7UjIeLTh+6Bt2wBdlKlc871rdpyw8sgerRJreGTz/2EPhYl/LKn0qAKMnSpaFjGJ
	5mJQ2Pm1U7clY5Yc/hkncFts7E8wPvAHcDEMl1PVZO6GlJmXEeBt3veiif9McIVw7bhynl9WpHE
	odEzp8GEL/JxmpJ8toqRt6Llqm8j+qzbIE94nnwRNAYIVbp9Kaq53ynhHK1bFRbn5STZElbYz/Y
	tly106vy8e540ZQPuTO2CEo+pkipyyPpTRDI+lgju/DoqBD9luFLqvUK+IkcSGjq/1W+ijh0RJp
	u1eEr6VUdVovKtUelGuvqhs7P1KWkBg==
X-Received: by 2002:a05:6214:2c0f:b0:8ce:b2e9:a4bd with SMTP id
 6a1803df08f44-90c5eaf6f46mr112398486d6.17.1787217117566; Thu, 20 Aug 2026
 02:11:57 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 02:11:56 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 20 Aug 2026 02:11:56 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260818093102.06F091F000E9@smtp.kernel.org>
References: <20260818-gmem-no-return-page-v2-0-5298f42d49bb@google.com>
 <20260818-gmem-no-return-page-v2-4-5298f42d49bb@google.com> <20260818093102.06F091F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Date: Thu, 20 Aug 2026 02:11:56 -0700
X-Gm-Features: AcwNN1XbpH7Dzoo1BVfklWznhbNlM9Zw2DBzd218nK1edqRg34m39L76lh6iCww
Message-ID: <CAEvNRgF08W_KvBvdxFskPu5rH1hhUyNm9GoVZXEq4w09o3qWKA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] KVM: guest_memfd: Stop returning struct page from
 PFN lookup
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, kvm@vger.kernel.org, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sashiko-bot@kernel.org writes:

> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [Critical] Concurrent execution of KVM_SEV_SNP_LAUNCH_UPDATE and a vCPU=
 page fault triggers a race condition leading to a host kernel panic.
> --
>
> --- Patch [4]: [PATCH v2 4/4] KVM: guest_memfd: Stop returning struct pag=
e from PFN lookup ---
> commit 766989bc1910148a83bffa481ae22b1d1eb71f01
> Author: Sean Christopherson <seanjc@google.com>
>
> KVM: guest_memfd: Stop returning struct page from PFN lookup
>
> This commit stops returning a refcounted struct page from guest_memfd PFN
> lookups, dropping the folio reference immediately instead. This prevents
> concurrent guest page faults from holding elevated refcounts that would
> interfere with in-place memory conversions between shared and private sta=
tes.
>
> Link: https://lore.kernel.org/all/anZ4W9o5pTWIEgMY@yzhao56-desk.sh.intel.=
com/
>
>> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
>> index b596486d184ca..589762140c3ef 100644
>> --- a/virt/kvm/guest_memfd.c
>> +++ b/virt/kvm/guest_memfd.c
>
> [ ... ]
>
>> @@ -780,11 +779,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_me=
mory_slot *slot,
>>  #endif
>>
>>  	folio_unlock(folio);
>> -
>> -	if (!r)
>> -		*page =3D folio_file_page(folio, index);
>> -	else
>> -		folio_put(folio);
>> +	folio_put(folio);
>>
>>  	return r;
>>  }
>
> [Severity: Critical]
> This is a pre-existing issue, but is it possible for a concurrent page
> fault to trigger a host kernel panic via a hardware RMP fault here?
>

I thought guest vCPU faults and populate are mutually exclusive, but I
couldn't actually find anything that blocks populate from running after
a guest is finalized.

So suppose the vCPU does fault in a page, the zeroing and make_private
happens under folio lock. After the page is obtained on the populate
side, there's no more zeroing, and sev_gmem_post_populate() would fail
since the page is already assigned.

Suppose populate goes first, the folio_lock keeps the vCPU fault
out. The folio is zeroed and made private. This time,
sev_gmem_post_populate() would fail because the guest has been
finalized. Still no zeroing after making private.

If populate finishes successfully, then the folio is marked
uptodate. This is done outside of the folio_lock(), but at this time the
vCPU can't run so by the time any vCPU fault can happen, the folio would
be uptodate, and there would be no more zeroing.

Seems like all is good.

After conversions, filemap_invalidate_lock() would make getting a pfn
and populate exclusive, so that's even better.

Let me know if I missed anything.

> Looking at kvm_gmem_get_pfn() in virt/kvm/guest_memfd.c, if the folio is
> not up to date, it zeroes the page and marks it up to date:
>
>     if (!folio_test_uptodate(folio)) {
>         clear_highpage(folio_page(folio, 0));
>         folio_mark_uptodate(folio);
>     }
>
> However, in the KVM_SEV_SNP_LAUNCH_UPDATE path, __kvm_gmem_populate()
> fetches a folio, unlocks it, and calls post_populate() (which maps to
> sev_gmem_post_populate() and calls rmp_make_private()) before finally
> marking the folio up to date.
>
> If a malicious userspace process races a vCPU page fault against
> KVM_SEV_SNP_LAUNCH_UPDATE, could the vCPU thread running kvm_gmem_get_pfn=
()
> acquire the lock on the not-yet-uptodate folio and call clear_highpage()
> after rmp_make_private() has already executed?
>
> If clear_highpage() writes to the page after it has been made RMP-private=
,
> this would trigger a fatal hardware RMP fault on the host CPU. If it writ=
es
> just before, it appears it could silently corrupt the encrypted firmware
> payload.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260818-gmem-no-=
return-page-v2-0-5298f42d49bb@google.com?part=3D4
