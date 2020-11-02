Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B75BC00A89
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 05:30:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91A5622268
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 05:30:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZYsF97dy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91A5622268
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D55924B57E;
	Mon,  2 Nov 2020 00:30:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ndrSSlPgmDMz; Mon,  2 Nov 2020 00:30:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DF84D4B2DD;
	Mon,  2 Nov 2020 00:30:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C944B2DD
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 00:30:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2EKhD3YDqDom for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 00:30:34 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D6234B28D
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 00:30:34 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1604295034;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=3opAEbPbu0I7/3XGmfBEZuV1m7H7G6E2oolgvdqsY6c=;
 b=ZYsF97dyw5YiJRSw3ekTrJpf3JIt6Ggn+tosXotvABAzU5mM5PIn31K716adU7BlxmOLta
 AyRohEwfewUD/3KIGu8KbpbTcgv7vKRTUe0DRBUikN3lmAutj2+74sZ3/4/lL/nPhVfbGF
 bmV6d8++198Q9sXMhWixOfszjnpcUQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-3DmDKEWtOQ6DE8PQoLvfcQ-1; Mon, 02 Nov 2020 00:30:32 -0500
X-MC-Unique: 3DmDKEWtOQ6DE8PQoLvfcQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2461E1084C86;
 Mon,  2 Nov 2020 05:30:31 +0000 (UTC)
Received: from [10.64.54.160] (vpn2-54-160.bne.redhat.com [10.64.54.160])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 412475D9DD;
 Mon,  2 Nov 2020 05:30:29 +0000 (UTC)
Subject: Re: [PATCH 3/6] kvm/arm64: Export kvm_handle_user_mem_abort() with
 prefault mode
To: James Morse <james.morse@arm.com>, kvmarm@lists.cs.columbia.edu
References: <20200818011319.91777-1-gshan@redhat.com>
 <20200818011319.91777-4-gshan@redhat.com>
 <43da773d-a218-ffb4-5648-19cc771c55e8@arm.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <39ac2d90-098d-4ad8-5188-023730a3e2ac@redhat.com>
Date: Mon, 2 Nov 2020 16:30:27 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <43da773d-a218-ffb4-5648-19cc771c55e8@arm.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: maz@kernel.org, will@kernel.org, shan.gavin@gmail.com, pbonzini@redhat.com
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

Hi James,

On 10/24/20 3:54 AM, James Morse wrote:
> On 18/08/2020 02:13, Gavin Shan wrote:
>> This renames user_mem_abort() to kvm_handle_user_mem_abort(), and
>> then exports it. The function will be used in asynchronous page fault
>> to populate a page table entry once the corresponding page is populated
>> from the backup device (e.g. swap partition):
>>
>>     * Parameter @fault_status is replace by @esr.
>>     * Parameter @prefault is added
>>
>> As the @esr is passed as parameter, not fetched from vCPU struct. This
>> also introduces the necessasry helpers in esr.h, to manupulate the @esr.
> 
> (Nit: necessary, manipulate)
> 

Thanks for your comments. It will be fixed in next revision :)

> 
>> The helpers defined in kvm_emulate.h reuses the newly added helper. This
>> shouldn't cause functional changes.
> 
> user_mem_abort() is deep in the the guts of KVM's arch code. I don't think this should be
> exported. It  must be called on the vcpu thread. It must be called under the VMs srcu
> lock. There are also tricky interactions with whether the vcpu is loaded on this cpu or not...
> 
> I think it would be much simpler to always let the guest take the stage2-fault a second
> time. This keeps the property that pages are only populate in response to a stage2 fault.
> If the guest behaves, it will only schedule a task that accesses the page once its available.
> 
> 

The function is called with SRCU hold in this patchset. However, it seems
more reasonable to be called in vCPU thread. On the other hand, I'm worrying
about the performance degradation. I will evaluate it in next revision and
leave the function is called in vCPU thread if performance is acceptable.
Otherwise, I would like to leave it as of being :)

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
