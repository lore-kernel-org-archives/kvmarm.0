Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.189
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794229949;
	b=VX4YZGWlbOgK1p+71G0U8EOkhfjn5SPhTYTaoFDBftmtebGRB6rMBWCAqU58G7bs1UK3
	 b80bkPX+ZuLta0YSqYgtRNgm7LirtUJNoESXcnNxLn8ccKKfPVdonibmmxeYeG91V2eCu
	 HV9Tqsnsu4hLGqNNNVEKgDOaiMSEmtAKC4t+LkeDwyJhapo9eSjV77FDdglCNaoPfnIch
	 KRD3xKtcPm1Wksw8/DwmflCa3U/MgxVXIXasJ2JCJ5whyDocQ1W6geGMEY6vSqhpk62TL
	 +2nCTdu+epvXBLu1Ik3Txr7gNh5VRhD07jDljP3WlVAfvQS9RW8iPL5xjPXjDRl36vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794229949;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=VcGX3S/ok2ofcwS3uJdO8rQXnNkquiVnumUqc1g1VFE=;
	b=cVRYJIoWXaqeTP9a7h7L2BNZy1FSYb56GH0vBYsLjtuDG16jy+K4gSDI4q22dL01HHI7
	 XuF2coe5OdUiy6R0M22Cj+DvdOaBHdYNqoaWIVDan9z0m8B+4Ybtemdr/UOPP/LBfWlrW
	 pVPA0VUZ4wsItQBw/fGTEGg6YLtzDEhcsuoB6xyIRE/UBVGs3aHOdWLrnWLlSdu70rXRK
	 oADKqjmTwewJES5VKeLxmoZ0CWUz6UmRcfgmSVQR1QvG3YDdVOZxfyVgMgibUTmEoTZ0H
	 5BcgHhOLAwQorsfwUrNy34fUOCw/DVY7VpkBV0ZcmuJl/z7ZVLrCMbLWakPxL/cyoJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TAPWF1vE;
	arc=none smtp.remote-ip=91.218.175.189
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09361606A322
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 13:12:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 09361606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TAPWF1vE
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=9ZfmGyDfW24qGm7656Xt3E7F30kmlnVfQdHu0DS+Udo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794229947; v=1; x=1794834747;
 b=TAPWF1vE23T/rmSuzIaKjZULYiIASkCK5Il444WSwHX1hqQzfwlJhqS5SOswi9ALc/i1sO8y
 ZnQjxzIBeC54/HBDUrH2Dg5svQIEK8hfSoJEJRDclhZnrArh5V1IR9OsfarHkaGQhdwSyh8ToWL
 Oth2Wsq7bTs9vnwi8RsBOiTA=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 7d0f6bbc84b1c2d6;
	Mon, 09 Nov 2026 13:12:27 +0000
X-Mizu-Trace-ID: 7d0f6bbc84b1c2d6
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5c144eb2f43so3407e87.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Nov 2026 05:12:26 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHmnpS9bRK0vgva4Z+KanXmlwpSjEy0Cl8ZLjutS77eDWM/T2pel9kYdaHs6suDFcE7V/ntKjs=@lists.linux.dev
X-Gm-Message-State: APuU4Z/6kQFHY9y0N4Wd6tASpL4phmMPmzSiI9rMrJxCYyMV77PM8WHi
	T8a8Q9PQgNJ2/NmGTaWqk16CgbE/fbVUsyhCDW1F2/tNh5+iGOSS2xwmQyJVicYRQDV7edddiFa
	oZjA5dbGrIHggdJXt8SM/tKh53a8SAZRGnvvKKiM2
X-Received: by 2002:a05:6512:1109:b0:5bf:c3e1:532b with SMTP id
 2adb3069b0e04-5c00b60a427mr195461e87.5.1794229945777; Mon, 09 Nov 2026
 05:12:25 -0800 (PST)
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <20261102141304.126883-1-steven.price@arm.com> <20261102141304.126883-11-steven.price@arm.com>
 <fa0ee5a1-4c49-4c1f-bfbb-c270dc4b6301@arm.com> <CA+EHjTy970AWnhYoZ5OqxQ8ojCAELeejw60y2NmpDsM_ZMdu4Q@mail.gmail.com>
 <06e52c9c-9026-4279-b8c0-53a54a667dad@arm.com>
In-Reply-To: <06e52c9c-9026-4279-b8c0-53a54a667dad@arm.com>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Mon, 9 Nov 2026 13:11:49 +0000
X-Gmail-Original-Message-ID: <CA+EHjTzJ1O8=q0rL5CkLKN3CBDr=TkujEw_M-W0H=BJfmrTEzg@mail.gmail.com>
X-Gm-Features: AclHuK9lv_i4f5zskQj2LbWryVS8Q4D5sdKCijE4VdtfsoeeW5x-cT5K6pQCDgo
Message-ID: <CA+EHjTzJ1O8=q0rL5CkLKN3CBDr=TkujEw_M-W0H=BJfmrTEzg@mail.gmail.com>
Subject: Re: [PATCH 10/11] KVM: arm64: CCA: Support runtime faulting of memory
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>, 
	Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Suzuki,

On Mon, 09 Nov 2026 11:35:31 +0000, Suzuki K Poulose
<suzuki.poulose@arm.com> wrote:
[...]
>> applies as is. Only how the expected state is computed differs: for a
>> pVM it comes from the per-page share state rather than an IPA bit.
>
> When you say, per-page, you mean per-IPA or per "backing page" ? i.e.,
> can pKVM do something like :
>
>     kvm_ipa_is_private(kvm, ipa) ?
>
> (similar to Realm) or does it need the struct page backing the "ipa" ?

Per IPA, so kvm_ipa_is_private(kvm, ipa) would work for pKVM too. A
pVM's page is private unless the guest has shared it, and that state
is in its stage-2 PTE at EL2, not in the struct page. The host kernel
doesn't have a copy today, since EL2 handles the share and unshare
hypercalls and the new state is only at EL2, so the pKVM side of the
check, a hypercall or a host-side mirror, is part of pKVM's
guest_memfd support when that lands.

Cheers,
/fuad
