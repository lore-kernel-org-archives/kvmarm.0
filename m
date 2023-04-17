Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D94E51848
	for <kvmarm@lists.linux.dev>; Mon, 17 Apr 2023 06:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1681713720;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=41kcF5/H9ceRzGEB/OQxlWiFDnnt6nMcXOxmlcq8A3s=;
	b=hvNqTgUCc7TjS9WL3gjl+6IKWyCqY2kbkpyDr4+YzKDK1uwoZgiTgpricjq0oFXrMadtTc
	7KI9nPZk1KK0qx9WNRiraWTTsBaiuyusfiDgQ7Kmt7j5QtziF5pjMX2HQ3t799jd8kmWFX
	R8cZp5vZfqKrh9QZzdaiIoU+ei/r0RU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-130-4-omMUukOICZFWTIVb66lg-1; Mon, 17 Apr 2023 02:41:55 -0400
X-MC-Unique: 4-omMUukOICZFWTIVb66lg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7E1C6855315;
	Mon, 17 Apr 2023 06:41:54 +0000 (UTC)
Received: from [10.72.13.187] (ovpn-13-187.pek2.redhat.com [10.72.13.187])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id AE76614171B8;
	Mon, 17 Apr 2023 06:41:43 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v7 05/12] KVM: arm64: Refactor
 kvm_arch_commit_memory_region()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com, Shaoqin Huang <shahuang@redhat.com>
References: <20230409063000.3559991-1-ricarkol@google.com>
 <20230409063000.3559991-7-ricarkol@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <2819bd9d-9a8c-938c-9297-86c1b8614550@redhat.com>
Date: Mon, 17 Apr 2023 14:41:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230409063000.3559991-7-ricarkol@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7

On 4/9/23 2:29 PM, Ricardo Koller wrote:
> Refactor kvm_arch_commit_memory_region() as a preparation for a future
> commit to look cleaner and more understandable. Also, it looks more
> like its x86 counterpart (in kvm_mmu_slot_apply_flags()).
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/mmu.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
> 

With the following nits addressed:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index efdaab3f154de..37d7d2aa472ab 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1761,20 +1761,27 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>   				   const struct kvm_memory_slot *new,
>   				   enum kvm_mr_change change)
>   {
> +	bool log_dirty_pages = new && new->flags & KVM_MEM_LOG_DIRTY_PAGES;
> +
>   	/*
>   	 * At this point memslot has been committed and there is an
>   	 * allocated dirty_bitmap[], dirty pages will be tracked while the
>   	 * memory slot is write protected.
>   	 */
> -	if (change != KVM_MR_DELETE && new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> +	if (log_dirty_pages) {
> +
> +		if (change == KVM_MR_DELETE)
> +			return;
> +
>   		/*
>   		 * If we're with initial-all-set, we don't need to write
>   		 * protect any pages because they're all reported as dirty.
>   		 * Huge pages and normal pages will be write protect gradually.
>   		 */

The comments need to be adjusted after this series is applied. The huge pages
won't be write protected gradually. Instead, the huge pages will be split and
write protected in one shoot.

> -		if (!kvm_dirty_log_manual_protect_and_init_set(kvm)) {
> -			kvm_mmu_wp_memory_region(kvm, new->id);
> -		}
> +		if (kvm_dirty_log_manual_protect_and_init_set(kvm))
> +			return;
> +
> +		kvm_mmu_wp_memory_region(kvm, new->id);
>   	}
>   }
>   
> 

Thanks,
Gavin

