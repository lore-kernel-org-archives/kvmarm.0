Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 514E6320A
	for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 20:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1682023944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R5Co2BkbmQDmd1M15a18Ma3/6BF2fWXYzajJ3Tdrdrw=;
	b=UIPIhTd857jXBEs8TziWbSEjrIqDw/vg7nlWQTDZD/yC8VnscgJ/3WNPK7J4ujzVO3b1Ip
	L8d7CdMTl8fB+4hGDs2b3h5mMz7tkxceTZVsAJv+mqTnZuwMs3zpcQk2daaCDTCt/6kaf2
	50ZLRa0izmsdpFGodLJOkAuFUbNrnf4=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604--kKipYKvOyKvAaGzlLd15w-1; Thu, 20 Apr 2023 16:52:21 -0400
X-MC-Unique: -kKipYKvOyKvAaGzlLd15w-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3ef2cb3bfbfso3681211cf.0
        for <kvmarm@lists.linux.dev>; Thu, 20 Apr 2023 13:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682023940; x=1684615940;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5Co2BkbmQDmd1M15a18Ma3/6BF2fWXYzajJ3Tdrdrw=;
        b=UhjyfY1d6FAnTZUS45TV4g5JMCEaf8UHtwX9y6HRjKh3iEWe23oZLBQheR2cXzJP/Q
         xXurB/mxBDa4MgxZgdUIPlPpt+GxWlAAbXy5yDb6uOEGIJr03w9Iyb7AM7vWmrskPbfq
         N3z3958mkTWfyj7F3ZZfrUVhUiluKp++yOLsu17cEw5R0MTSIPRtbIshkJE1ugVSDshm
         LzHVmjyiw0HDyt/iwxdOp+Jn9DS7vpintoknpllQ0Yt/Fna5uVUHyurjEhtQM8lpV3jw
         YaVLWA5/d/p+AOvtQQE/gITmSDd0oqx4GKnjoVcM0x7tnOE9FwCFwKTbaf2KWz3QNcTv
         Z1TA==
X-Gm-Message-State: AAQBX9eUOjrN0kI7VQUtYwOiTVuyyymJ29/s0w0A+uDS5ULyYvgb03L6
	iqIfDSIEmwrqPaiRhnuG4KssXXA5AgBZ6zCEcVLsqTx+1CGw+ioiUYGLBso9rAZ5VH74GnF79GM
	hOdlRAf23AwrQZa7p
X-Received: by 2002:a05:622a:1a1a:b0:3b8:36f8:830e with SMTP id f26-20020a05622a1a1a00b003b836f8830emr4713288qtb.6.1682023940690;
        Thu, 20 Apr 2023 13:52:20 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZXCY19Yj/E+BEr/ubLXULAq+ANh15aYSC2LqGjLgngRSReEqE/xKadWhwBb6lg0GvqOg+jfw==
X-Received: by 2002:a05:622a:1a1a:b0:3b8:36f8:830e with SMTP id f26-20020a05622a1a1a00b003b836f8830emr4713261qtb.6.1682023940401;
        Thu, 20 Apr 2023 13:52:20 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id b10-20020a05622a020a00b003e65228ef54sm753879qtx.86.2023.04.20.13.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 13:52:19 -0700 (PDT)
Date: Thu, 20 Apr 2023 16:52:18 -0400
From: Peter Xu <peterx@redhat.com>
To: Anish Moorthy <amoorthy@google.com>
Cc: pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
	seanjc@google.com, jthoughton@google.com, bgardon@google.com,
	dmatlack@google.com, ricarkol@google.com, axelrasmussen@google.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v3 07/22] KVM: Annotate -EFAULTs from
 kvm_vcpu_write_guest_page()
Message-ID: <ZEGmAnnv5Dq8BgrW@x1n>
References: <20230412213510.1220557-1-amoorthy@google.com>
 <20230412213510.1220557-8-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230412213510.1220557-8-amoorthy@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Wed, Apr 12, 2023 at 09:34:55PM +0000, Anish Moorthy wrote:
> Implement KVM_CAP_MEMORY_FAULT_INFO for efaults from
> kvm_vcpu_write_guest_page()
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 63b4285d858d1..b29a38af543f0 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3119,8 +3119,11 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  			      const void *data, int offset, int len)
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> +	int ret = __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
>  
> -	return __kvm_write_guest_page(vcpu->kvm, slot, gfn, data, offset, len);
> +	if (ret == -EFAULT)
> +		kvm_populate_efault_info(vcpu, gfn * PAGE_SIZE + offset, len);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);

Why need to trap this?  Is this -EFAULT part of the "scalable userfault"
plan or not?

My previous memory was one can still leave things like copy_to_user() to go
via the userfaults channels which should work in parallel with the new vcpu
MEMORY_FAULT exit.  But maybe the plan changed?

Thanks,

-- 
Peter Xu

