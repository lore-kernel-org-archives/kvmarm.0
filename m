Return-Path: <SRS0=046z=DI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B88F9C4363D
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 00:59:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0644E2085B
	for <kvmarm@archiver.kernel.org>; Thu,  1 Oct 2020 00:59:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Uxmskj/Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0644E2085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BC4C4B2FD;
	Wed, 30 Sep 2020 20:59:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3VzGBVuBlGJO; Wed, 30 Sep 2020 20:59:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 478094B300;
	Wed, 30 Sep 2020 20:59:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65C414B2FC
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 20:59:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Yjg9TNP1VrwR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Sep 2020 20:59:27 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 460904B2F9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Sep 2020 20:59:27 -0400 (EDT)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1601513967;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=erSG8klwe4cnhaeLGnmbABbg8+wPvNswSqySv2lUFVM=;
 b=Uxmskj/ZtaKAPjNo/pBBPEazfaZb+ioh8U0UKOWK4WZUxtOS63QzBigqmyaOWcx76SUYW3
 A8Sl03cQd8qnvejbBOW5ZDzu7lYRmyaeRLK9gyYmDNlNtFwDXElGcDDVdVZveKN8bneEne
 SPTYp2qVorLzcO99zzMamAp62ggXPa8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-9-Ca4idoNc-wKdzx9hz_Xw-1; Wed, 30 Sep 2020 20:59:22 -0400
X-MC-Unique: 9-Ca4idoNc-wKdzx9hz_Xw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 289F51074642;
 Thu,  1 Oct 2020 00:59:21 +0000 (UTC)
Received: from [10.64.54.133] (vpn2-54-133.bne.redhat.com [10.64.54.133])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 00F0D5D9D3;
 Thu,  1 Oct 2020 00:59:18 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: Ensure user_mem_abort() return value is
 initialised
To: Will Deacon <will@kernel.org>, maz@kernel.org
References: <20200930102442.16142-1-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <da406d3e-688d-932a-bdae-be932acb3a55@redhat.com>
Date: Thu, 1 Oct 2020 10:59:16 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200930102442.16142-1-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel test robot <lkp@intel.com>, Will Deacon <willdeacon@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 Dan Carpenter <dan.carpenter@oracle.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

On 9/30/20 8:24 PM, Will Deacon wrote:
> From: Will Deacon <willdeacon@google.com>
> 
> If a change in the MMU notifier sequence number forces user_mem_abort()
> to return early when attempting to handle a stage-2 fault, we return
> uninitialised stack to kvm_handle_guest_abort(), which could potentially
> result in the injection of an external abort into the guest or a spurious
> return to userspace. Neither or these are what we want to do.
> 
> Initialise 'ret' to 0 in user_mem_abort() so that bailing due to a
> change in the MMU notrifier sequence number is treated as though the
> fault was handled.
> 
> Cc: Gavin Shan <gshan@redhat.com>
> Cc: Alexandru Elisei <alexandru.elisei@arm.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> Applies on top of kvmarm/next.
> 
>   arch/arm64/kvm/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index c5c26a9cb85b..a816cb8e619b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -742,7 +742,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   			  struct kvm_memory_slot *memslot, unsigned long hva,
>   			  unsigned long fault_status)
>   {
> -	int ret;
> +	int ret = 0;
>   	bool write_fault, writable, force_pte = false;
>   	bool exec_fault;
>   	bool device = false;
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
