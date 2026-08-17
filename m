Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB374B04A7
	for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 09:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786959631; cv=none; b=VYabKqIHy6UMxfY39KTxEisNNuBjvDBH1SlSL6ABQzQD5LDY/zCmg2WCVQkLQBw9th1Bl8OOKhKJUBQqQMIJAc2bUbIEMtqh4v4bfg2a/Fu2/AnkS0FdUOBk6tA5bpOW19Ah1oB/3KMVHIJWoEEYUY5xVc/CuFkQA51iRNsTbgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786959631; c=relaxed/simple;
	bh=cAGH7X2mNwTe3zgPhEeT65t4xxAxjifjKMrHei774+0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bz5YgdJ1FIqgn/qKy79td9uJZgo3/HHRbwB+hlYH4LFDH35DmjHMxekpDjLsUDQSP8/RUjt/49wjUMI2aV+aya/ofkaUxxAZE3rg8tjJNCAeZLY+vtXV3+EqNdmF2Fx4mpHqw/ZRNLVBgWB3MRPjSf3R3EuEKgx0ZLcCzzh3KUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DluYPYKO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DluYPYKO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786959622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cXNSYsF9vRwZXPBJJcxBVs1JLk+WZ0B+/fXzS8/IT3Y=;
	b=DluYPYKOIfWwZJVB3AfzrhLjkNgL0pRD86OfVKF25XDQUZ2GSht2449jQrwtRRXAsyPIry
	7fweeQI477F497STN/QUsv2H/3QQ+Hl3sOARoi6Qo8FcOnji7Uh0kY8u6GSVO4AVmW6vg2
	u86d/quC+4Ngn29RrYNXQWX23VuoSi0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-_31f73PsNAGgnWOhsO_NMw-1; Mon, 17 Aug 2026 05:40:19 -0400
X-MC-Unique: _31f73PsNAGgnWOhsO_NMw-1
X-Mimecast-MFC-AGG-ID: _31f73PsNAGgnWOhsO_NMw_1786959618
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-495529a93f9so31452655e9.3
        for <kvmarm@lists.linux.dev>; Mon, 17 Aug 2026 02:40:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786959618; x=1787564418;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cXNSYsF9vRwZXPBJJcxBVs1JLk+WZ0B+/fXzS8/IT3Y=;
        b=rkUpkkNYi/pHBnso4I4y5VgUML60sVXec+28YvIT2jTlYaA7cloyzjJ0nDVjwQKIfI
         PXpui5furi5N5qUpQQM7cu+1BKrux0BCS8gPs8DZLNXhEO6XkqgLhXqMXXkdTAbaAxB7
         pKMJ4UxM34Kn2OPOob5yDw//M3vtLo7WhwJ14nAE5l2WAei6dGs+qtybW8SS4a0tM/Oo
         eFxC1r2tZdvsAHztBXTgktGvlkDcXGzwYjP6WyqFsUattWUrQ5WhCZyX9I4Te81D5PZT
         GKt0l7fWV4/kQGAJixLV1BeJ8hKQnTVrMIti6imWxm6I4AzihUQWD9ATDybyOVHZm453
         1hZA==
X-Forwarded-Encrypted: i=1; AHgh+RqjcJpS2OcH3BqZyeJvQPwG0aUR0d09rWS9IvNIQAZN0ghEJaaeHZUUIgR8SXfesb4kgGAUgf8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxc6C6MqSD5JxXBdhGzwwdYE37Aj0rN4Pi1nMn3tQTIPyVrVOOm
	zpIGSOMJnq901NjD6N4Pejh/QVBrrxJrOfBZhlxGDYpdMGl6xlm+qdlD2zM54hlFyRTmBMcuYcb
	zQz5Aj4Ol/qcWu65b/NRf1MN70OWfQmfPCCeaMTk3TOpXiyfGclNKCnrb5A==
X-Gm-Gg: AR+sD11xNLgcQZ4H/tNw4/+FWi/f0QK+8kePBdKQnuXpwD3LNQGC16HjN4TH58FsXM0
	ABkorPXXTvHvVJYEgoOc4NEBWJ64hWZjl6IBq1rMF1asERroAdk4ZiAXXdEBy9lLu4LNZDJTLxC
	cWX5t53pwkw3QX6eerfIAhx30QZfcMYbX/s0FmnklUnQefUOmHZ4fRbLEH433i44ikpqMWua0LF
	fxgtX9uvpm73j6UfmSJyWHzx5NoOxsodvH9EGtuUZGdQ5XjEfCcfbmzcprMJl29LQPi+V0qKdJG
	obH2ZnHuTOsIaVftEJWefqGW+tV0GUzLri+W/lkwAWIM/kuaQ0qZliJLaMwkYGbtj0DxGhnhv/G
	TxNst8/IWZr9MuF9GGi3qUs9BFRCOVFZf7NKtDCOGMHU=
X-Received: by 2002:a05:600c:46d4:b0:499:8aff:59b6 with SMTP id 5b1f17b1804b1-4998aff59d6mr271618555e9.14.1786959617865;
        Mon, 17 Aug 2026 02:40:17 -0700 (PDT)
X-Received: by 2002:a05:600c:46d4:b0:499:8aff:59b6 with SMTP id 5b1f17b1804b1-4998aff59d6mr271617765e9.14.1786959617249;
        Mon, 17 Aug 2026 02:40:17 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:f0e:9070:527b:9dff:feef:3874? ([2a01:e0a:f0e:9070:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49996109652sm166024305e9.4.2026.08.17.02.40.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 02:40:16 -0700 (PDT)
Message-ID: <99991405-f05d-48c9-9f5f-42871d0714cc@redhat.com>
Date: Mon, 17 Aug 2026 11:40:15 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: arm64: vgic-its: Reword the comment on a
 collection-less ITE
To: Fuad Tabba <fuad.tabba@linux.dev>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oupton@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, Will Deacon <will@kernel.org>,
 Sascha Bischoff <sascha.bischoff@arm.com>,
 Sebastian Ene <sebastianene@google.com>, Fuad Tabba <tabba@google.com>,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20260817092705.1112634-1-fuad.tabba@linux.dev>
From: Eric Auger <eauger@redhat.com>
In-Reply-To: <20260817092705.1112634-1-fuad.tabba@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MIAePdVIebNjroCLuWXn0te-ugaViSiU4GN0a8LLrI0_1786959618
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/17/26 11:27 AM, Fuad Tabba wrote:
> The comment above the NULL collection check in vgic_its_save_ite()
> names only MAPC with V=0, which is UNPREDICTABLE. The route that
> requires the check is clearing GITS_BASER<coll>.Valid on a disabled
> ITS, a legitimate operation that orphans every ITE at once. Name both
> routes.
> 
> No functional change intended.
> 
> Suggested-by: Eric Auger <eauger@redhat.com>
> Link: https://lore.kernel.org/all/0ce5e496-a067-48fd-80d2-94fe9981d505@redhat.com/
> Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric


> ---
> 
> Notes:
>     Based on kvmarm/next, since the comment this reworks was added by
>     c6c156d931c3 ("KVM: arm64: vgic-its: Don't dereference a NULL collection
>     on ITT save") and is not in a release yet.
> 
>  arch/arm64/kvm/vgic/vgic-its.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index f6538b1976f9b..26c665e0a2386 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -2112,9 +2112,9 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
>  	u64 val;
>  
>  	/*
> -	 * MAPC with V=0 keeps the ITEs mapped but drops their collection,
> -	 * and with it the ICID. Save a zeroed entry, which the restore path
> -	 * reads back as invalid.
> +	 * MAPC with V=0 and clearing GITS_BASER<coll>.Valid both keep the
> +	 * ITEs mapped while dropping their collection, and with it the ICID.
> +	 * Save a zeroed entry, which the restore path reads back as invalid.
>  	 */
>  	if (!ite->collection)
>  		return vgic_its_write_entry_lock(its, gpa, 0ULL, ite);
> 
> base-commit: 57e7cf13ac26bf1a3dba6cfa601f7b2481811575

