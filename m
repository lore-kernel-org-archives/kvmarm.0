Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B67F256E
	for <kvmarm@lists.linux.dev>; Fri, 20 Jan 2023 14:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1674224095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EidcY9Cmvk5OofxEtF9K5cCW7yBrnPNvX2al+ZtoBes=;
	b=d8ZKNHtRGcIGVRbDVxT8QitFs9FQVvehmEWG5Fb6d1MSzT2pB4uCj1JOvVHRTEYhslILwj
	TBW1gtu3KYSFjGWeVPV/X+ki/ak0bSc/SY5CozqOb/jZm4+kvUhQB3HLlq1oBvfhNKhjIO
	5wqLZ/VxorkRtRid2uaS9hmUgyFoEGE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-_ez66BcsNz2ryGRk3A1axQ-1; Fri, 20 Jan 2023 09:14:52 -0500
X-MC-Unique: _ez66BcsNz2ryGRk3A1axQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E52E31818E7D;
	Fri, 20 Jan 2023 14:14:50 +0000 (UTC)
Received: from localhost (unknown [10.39.193.175])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 8486F1415113;
	Fri, 20 Jan 2023 14:14:50 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH] KVM: arm64: Pass the actual page address to
 mte_clear_page_tags()
In-Reply-To: <20230119170902.1574756-1-catalin.marinas@arm.com>
Organization: Red Hat GmbH
References: <20230119170902.1574756-1-catalin.marinas@arm.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date: Fri, 20 Jan 2023 15:14:48 +0100
Message-ID: <87tu0lgunb.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Thu, Jan 19 2023, Catalin Marinas <catalin.marinas@arm.com> wrote:

> Commit d77e59a8fccd ("arm64: mte: Lock a page for MTE tag
> initialisation") added a call to mte_clear_page_tags() in case a
> prior mte_copy_tags_from_user() failed in order to avoid stale tags in
> the guest page (it should have really been a separate commit).
> Unfortunately, the argument passed to this function was the address of
> the struct page rather than the actual page address. Fix this function
> call.
>
> Fixes: d77e59a8fccd ("arm64: mte: Lock a page for MTE tag initialisation")
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/guest.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 5626ddb540ce..cf4c495a4321 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -1079,7 +1079,7 @@ long kvm_vm_ioctl_mte_copy_tags(struct kvm *kvm,
>  
>  			/* uaccess failed, don't leave stale tags */
>  			if (num_tags != MTE_GRANULES_PER_PAGE)
> -				mte_clear_page_tags(page);
> +				mte_clear_page_tags(maddr);
>  			set_page_mte_tagged(page);
>  
>  			kvm_release_pfn_dirty(pfn);

Oops.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

