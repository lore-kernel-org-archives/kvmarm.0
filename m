Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 879B1CCA47D
	for <kvmarm@archiver.kernel.org>; Wed, 22 Jun 2022 14:26:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C4654B4C6;
	Wed, 22 Jun 2022 10:26:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wA2x1Jk6SI6n; Wed, 22 Jun 2022 10:26:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BCE6F4B4C8;
	Wed, 22 Jun 2022 10:26:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0A1994B4C6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 10:26:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22M4wMtKoFTr for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Jun 2022 10:26:35 -0400 (EDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com
 [209.85.218.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9023A4B4C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 10:26:35 -0400 (EDT)
Received: by mail-ej1-f52.google.com with SMTP id lw20so12293917ejb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Jun 2022 07:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=wUD/GjtbdHAWjsJjatle4okluorJj+57zXqxxgzmwbY=;
 b=ANfJshSMFlKiLNlul8iXqeedQaCgmiS1Gwvi4G7/gauIMDHChCzcqnG/Gb/1oKObDL
 VRJmChlDYRU1HTfS9cwgNYR034b5Ev2nNWpUCgHQhBL+l5mHos36fOl8GPkHNtPiZeWn
 sOThzD+3IvI2ZV5WEtfciGeZ5Kc740a/e/4QNgOj+VZsS1EktsV4dGj+vp47TBQMVY4m
 tTgs3VvfEdLwd+Q2XGBb5A5Rs55Of3BhEjJAqg1oIariGIQJ+3ibI+2riGsD3Lcp3bdK
 lQWU2H1xjs2k1p0zlR0YCvGZuQYJ5rxN0VDBMxLoWSAei8/B48bdWLV6quPg3CW3TofP
 +VqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=wUD/GjtbdHAWjsJjatle4okluorJj+57zXqxxgzmwbY=;
 b=6G2//hRZzwCx3izaCC3TJyej8cEcxpqXWKHo7n76Kwc/RzdO86MA6smbbTlaQMghXO
 YJ9j9DbhzLc0z5dm6fIipwykDuQ9kjA3xmQ1Ez6uUeWLB0HeXoVkuOOZxGBBlPwwjlqz
 knyUn4gL9uyyfV96ayh5VxR6X4X+rN2mzM0QbQ2ie24zmAdO3yecUjO72oxzYw4PlvxV
 ZBAdipiZhoTMTvuzZ3SIcHbxm6E1QSMpJYAr8sqNgq3GC4GZ1QHIN1wlRNZpzpMOQkZb
 DkfbzKj5v2F141FFn1hprGjVgy0u5NPq8kGFXTOFNYdBYSgzIU7/xwGjn0O3O9YDqcY/
 GoSg==
X-Gm-Message-State: AJIora+TKdBUrvIW29MeWzRZKnk+CAe5X6IwAOU1Yb4m1KxsvSXlqyMb
 MxkDGJveQb7YHQHqhOmOJsg=
X-Google-Smtp-Source: AGRyM1uz9zZ7gdiqcy1JZCzPpQm+1svO35QxQGOqXnVaCH1vVevoLYg2hnILTm/YwhNlaLR2Y7FtjQ==
X-Received: by 2002:a17:906:5354:b0:712:1f3c:2970 with SMTP id
 j20-20020a170906535400b007121f3c2970mr3369062ejo.29.1655907994389; 
 Wed, 22 Jun 2022 07:26:34 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89?
 ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
 by smtp.googlemail.com with ESMTPSA id
 ju27-20020a17090798bb00b00722e57fa051sm2632251ejc.90.2022.06.22.07.26.32
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Wed, 22 Jun 2022 07:26:33 -0700 (PDT)
Message-ID: <75f7f353-3cb1-8d0f-1148-8a916bf575a3@redhat.com>
Date: Wed, 22 Jun 2022 16:26:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 13/22] KVM: x86/mmu: Allow NULL @vcpu in
 kvm_mmu_find_shadow_page()
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-14-dmatlack@google.com> <YqydjxjnuaYTIYMt@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YqydjxjnuaYTIYMt@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, maciej.szmigiero@oracle.com,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 6/17/22 17:28, Sean Christopherson wrote:
> On Mon, May 16, 2022, David Matlack wrote:
>> Allow @vcpu to be NULL in kvm_mmu_find_shadow_page() (and its only
>> caller __kvm_mmu_get_shadow_page()). @vcpu is only required to sync
>> indirect shadow pages, so it's safe to pass in NULL when looking up
>> direct shadow pages.
>>
>> This will be used for doing eager page splitting, which allocates direct
> 
> "hugepage" again, because I need constant reminders :-)
> 
>> shadow pages from the context of a VM ioctl without access to a vCPU
>> pointer.
>>
>> Signed-off-by: David Matlack <dmatlack@google.com>
>> ---
> 
> With nits addressed,
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> 
>>   arch/x86/kvm/mmu/mmu.c | 13 +++++++++++++
>>   1 file changed, 13 insertions(+)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 4fbc2da47428..acb54d6e0ea5 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -1850,6 +1850,7 @@ static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>>   
>>   	if (ret < 0)
>>   		kvm_mmu_prepare_zap_page(vcpu->kvm, sp, invalid_list);
>> +
> 
> Unrelated whitespace change leftover from the previous approach.
> 
>>   	return ret;
>>   }
>>   
>> @@ -2001,6 +2002,7 @@ static void clear_sp_write_flooding_count(u64 *spte)
>>   	__clear_sp_write_flooding_count(sptep_to_sp(spte));
>>   }
>>   
>> +/* Note, @vcpu may be NULL if @role.direct is true. */
>>   static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
>>   						     struct kvm_vcpu *vcpu,
>>   						     gfn_t gfn,
>> @@ -2039,6 +2041,16 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
>>   			goto out;
>>   
>>   		if (sp->unsync) {
>> +			/*
>> +			 * A vCPU pointer should always be provided when finding
> 
> s/should/must, and "be provided" in unnecessarily ambiguous, simply state that
> "@vcpu must be non-NULL".  E.g. if a caller provides a pointer, but that pointer
> happens to be NULL.
> 
>> +			 * indirect shadow pages, as that shadow page may
>> +			 * already exist and need to be synced using the vCPU
>> +			 * pointer. Direct shadow pages are never unsync and
>> +			 * thus do not require a vCPU pointer.
>> +			 */
> 
> "vCPU pointer" over and over is a bit versbose, and I prefer to refer to vCPUs/VMs
> as objects themselves.  E.g. "XYZ requires a vCPU" versus "XYZ requires a vCPU
> pointer" since it's not the pointer itself that's required, it's all the context
> of the vCPU that is needed.
> 
> 			/*
> 			 * @vcpu must be non-NULL when finding indirect shadow
> 			 * pages, as such pages may already exist and need to
> 			 * be synced, which requires a vCPU.  Direct pages are
> 			 * never unsync and thus do not require a vCPU.
> 			 */

My own take:

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d7987420bb26..a7748c5a2385 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1975,7 +1975,12 @@ static void clear_sp_write_flooding_count(u64 *spte)
  	__clear_sp_write_flooding_count(sptep_to_sp(spte));
  }
  
-/* Note, @vcpu may be NULL if @role.direct is true. */
+/*
+ * The vCPU is required when finding indirect shadow pages; the shadow
+ * page may already exist and syncing it needs the vCPU pointer in
+ * order to read guest page tables.  Direct shadow pages are never
+ * unsync, thus @vcpu can be NULL if @role.direct is true.
+ */
  static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
  						     struct kvm_vcpu *vcpu,
  						     gfn_t gfn,
@@ -2014,13 +2019,6 @@ static struct kvm_mmu_page *kvm_mmu_find_shadow_page(struct kvm *kvm,
  			goto out;
  
  		if (sp->unsync) {
-			/*
-			 * The vCPU pointer is required when finding indirect
-			 * shadow pages, as that shadow page may already exist
-			 * exist and need to be synced using the vCPU pointer.
-			 * Direct shadow pages are never unsync and thus do not
-			 * require a vCPU pointer.
-			 */
  			if (KVM_BUG_ON(!vcpu, kvm))
  				break;
  
@@ -2101,7 +2099,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
  	return sp;
  }
  
-/* Note, @vcpu may be NULL if @role.direct is true. */
+/* Note, @vcpu may be NULL if @role.direct is true; see kvm_mmu_find_shadow_page. */
  static struct kvm_mmu_page *__kvm_mmu_get_shadow_page(struct kvm *kvm,
  						      struct kvm_vcpu *vcpu,
  						      struct shadow_page_caches *caches,

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
