Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03070C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 17:40:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FDA24B17C;
	Tue,  3 May 2022 13:40:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nQWA4yY9t4YX; Tue,  3 May 2022 13:40:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 128E04B11A;
	Tue,  3 May 2022 13:40:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B5D04B0ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 13:40:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 07pbmhWyDWhc for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 13:40:52 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CF564B086
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 13:40:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651599651;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=elECMtmMZllVEc4cR7ZLOEg0DEfCXom1q7YYKq/9EWM=;
 b=WsQkVB1c9j26B/LqrSv2z8XaScUpkhtCjKqlmXKN+u+p0aC6dbYdPffs6/viyAjfhkX/8P
 IHCZpsieaZn9zCS9L8TTFIq+giEYPXV41Vlt6FWFKh3gE1vxURMZT+R3VIy/W2WkCPchHM
 gINBBfF+wOWrKhl3fiNrkijwMm3Dq48=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-446-_j4XI3RCOuWD1OIVvhhsTQ-1; Tue, 03 May 2022 13:40:50 -0400
X-MC-Unique: _j4XI3RCOuWD1OIVvhhsTQ-1
Received: by mail-wm1-f71.google.com with SMTP id
 125-20020a1c0283000000b003928cd3853aso1651068wmc.9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 10:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=elECMtmMZllVEc4cR7ZLOEg0DEfCXom1q7YYKq/9EWM=;
 b=eo0kjjXF7KGEtyvwxgcwAeELmWTtvjoN54OdKLgUGJaXfI5MPFk0xUaiE4zZG59DMC
 RW/eNWzOLx2VUccKgvcwd51+7Nquq0GtcMTVEHRWw92vkRr/K5GNQv7FCHIsEZ+lxD19
 lPopi4o7CPZ5v+/OUwvO1Kmhl53wexHsxfbuKn9eqiZqAyoXsDMgGqugEXT3Xi/zWmDB
 twzho6wGmnoZh+ZLFDfQb4vBmyCrF7bU7g+wictWkamlOlXkCirTM0TJuGPDsrEECc7n
 9NM8Jnh1ulYKLpxk114cfbKNVjeEjxqhop5qP0w4STiT01ARcXv8b4kDEyO4UQUkP//9
 7L+Q==
X-Gm-Message-State: AOAM5302fdOkb+eS+QXWvdt7uPU/Wf1/awfJZdhuhOV85SfnEz3bQs7J
 4I3xvqIUKI2OTN9lzwy50vUUfdLGbgIFBkEjSoPOFVivUkYt5ejSvQB3NMB3QDlbTjrdmSBHaWA
 k9Zpjvt4SzdeqOKBxmPcmQqiC
X-Received: by 2002:adf:ee90:0:b0:20a:de35:14b4 with SMTP id
 b16-20020adfee90000000b0020ade3514b4mr13729560wro.558.1651599649364; 
 Tue, 03 May 2022 10:40:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8hBkHHn7iOsZtOm7YrEEIdMnX3D2t8E0X8gXbLIU+MdK7+3N3yPWthjRrSymAf+RGbtravw==
X-Received: by 2002:adf:ee90:0:b0:20a:de35:14b4 with SMTP id
 b16-20020adfee90000000b0020ade3514b4mr13729545wro.558.1651599649081; 
 Tue, 03 May 2022 10:40:49 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id
 ay32-20020a05600c1e2000b003942a244ebesm2131921wmb.3.2022.05.03.10.40.47
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 03 May 2022 10:40:48 -0700 (PDT)
Message-ID: <8cfeae8e-93f3-be10-8743-8d51b89b7a5a@redhat.com>
Date: Tue, 3 May 2022 19:40:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 3/4] KVM: arm64: vgic: Do not ignore
 vgic_its_restore_cte failures
To: Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
References: <20220427184814.2204513-1-ricarkol@google.com>
 <20220427184814.2204513-4-ricarkol@google.com>
From: Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20220427184814.2204513-4-ricarkol@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: andre.przywara@arm.com, pshier@google.com, maz@kernel.org,
 pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Ricardo,

On 4/27/22 20:48, Ricardo Koller wrote:
> Restoring a corrupted collection entry is being ignored and treated as
maybe precise what is a corrupted ITE (out of range id or not matching
guest RAM)
> success. More specifically, vgic_its_restore_cte failure is treated as
> success by vgic_its_restore_collection_table.  vgic_its_restore_cte uses
> a positive number to return ITS error codes, and +1 to return success.
Not fully correct as vgic_its_restore_cte() also returns a bunch of
generic negative error codes. vgic_its_alloc_collection() only returns
one positive ITS error code.
> The caller then uses "ret > 0" to check for success. An additional issue
> is that invalid entries return 0 and although that doesn't fail the
> restore, it leads to skipping all the next entries.
Isn't what we want. If I remember correctly an invalid entry corresponds
to the end of the collection table, hence the break.
see vgic_its_save_collection_table() and "add a last dummy element with
valid bit unset".
>
> Fix this by having vgic_its_restore_cte return negative numbers on
> error, and 0 on success (which includes skipping an invalid entry).
> While doing that, also fix alloc_collection return codes to not mix ITS
> error codes (positive numbers) and generic error codes (negative
> numbers).
>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c | 35 ++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index fb2d26a73880..86c26aaa8275 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -999,15 +999,16 @@ static bool vgic_its_check_event_id(struct vgic_its *its, struct its_device *dev
>  	return __is_visible_gfn_locked(its, gpa);
>  }
>  
> +/*
> + * Adds a new collection into the ITS collection table.
nit: s/Adds/Add here and below
> + * Returns 0 on success, and a negative error value for generic errors.
> + */
>  static int vgic_its_alloc_collection(struct vgic_its *its,
>  				     struct its_collection **colp,
>  				     u32 coll_id)
>  {
>  	struct its_collection *collection;
>  
> -	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
> -		return E_ITS_MAPC_COLLECTION_OOR;
> -
>  	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
>  	if (!collection)
>  		return -ENOMEM;
> @@ -1101,7 +1102,12 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>  
>  	collection = find_collection(its, coll_id);
>  	if (!collection) {
> -		int ret = vgic_its_alloc_collection(its, &collection, coll_id);
> +		int ret;
> +
> +		if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
> +			return E_ITS_MAPC_COLLECTION_OOR;
> +
> +		ret = vgic_its_alloc_collection(its, &collection, coll_id);
>  		if (ret)
>  			return ret;
>  		new_coll = collection;
> @@ -1256,6 +1262,10 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
>  		if (!collection) {
>  			int ret;
>  
> +			if (!vgic_its_check_id(its, its->baser_coll_table,
> +						coll_id, NULL))
> +				return E_ITS_MAPC_COLLECTION_OOR;
> +
>  			ret = vgic_its_alloc_collection(its, &collection,
>  							coll_id);
>  			if (ret)
> @@ -2497,6 +2507,10 @@ static int vgic_its_save_cte(struct vgic_its *its,
>  	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
>  }
>  
> +/*
> + * Restores a collection entry into the ITS collection table.
> + * Returns 0 on success, and a negative error value for generic errors.
> + */
>  static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
>  {
>  	struct its_collection *collection;
> @@ -2511,7 +2525,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
>  		return ret;
>  	val = le64_to_cpu(val);
>  	if (!(val & KVM_ITS_CTE_VALID_MASK))
> -		return 0;
> +		return 0; /* invalid entry, skip it */
>  
>  	target_addr = (u32)(val >> KVM_ITS_CTE_RDBASE_SHIFT);
>  	coll_id = val & KVM_ITS_CTE_ICID_MASK;
> @@ -2523,11 +2537,15 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
>  	collection = find_collection(its, coll_id);
>  	if (collection)
>  		return -EEXIST;
> +
> +	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
> +		return -EINVAL;
> +
>  	ret = vgic_its_alloc_collection(its, &collection, coll_id);
>  	if (ret)
>  		return ret;
>  	collection->target_addr = target_addr;
> -	return 1;
> +	return 0;
>  }
>  
>  /**
> @@ -2593,15 +2611,12 @@ static int vgic_its_restore_collection_table(struct vgic_its *its)
>  
>  	while (read < max_size) {
>  		ret = vgic_its_restore_cte(its, gpa, cte_esz);
> -		if (ret <= 0)
> +		if (ret < 0)
>  			break;
>  		gpa += cte_esz;
>  		read += cte_esz;
>  	}
>  
> -	if (ret > 0)
> -		return 0;
> -
>  	return ret;
>  }
>  
Thanks

Eric

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
