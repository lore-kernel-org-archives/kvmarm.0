Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC4EC433EF
	for <kvmarm@archiver.kernel.org>; Mon,  4 Apr 2022 10:53:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E70E4B214;
	Mon,  4 Apr 2022 06:53:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id e+Bc8mm+DqPq; Mon,  4 Apr 2022 06:53:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 754654B215;
	Mon,  4 Apr 2022 06:53:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6ACD049EE4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 06:53:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6AwhKX-k587a for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Apr 2022 06:53:29 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 60EB649EE0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Apr 2022 06:53:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649069609;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=nmzUc45Prh1+ExDpLCMwSGqWxkU2qU0qcCSpLdKeeqE=;
 b=U0vxHHIh5SpNXEaYBAsijfigUJb4okKdmZ7Onv1A7x1PeCQ9zqfysWu47tkxsraiqTGnX1
 eowovhm3eYoJiJjsWAXj1X3x1qoA3WskT4/wWbKJMBx8OCEfccfY9qAlPCZ0Nq7ADt/hrp
 TR322HHoJfqiz3bPEDlqiKnbanLMWzk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-TgDyIROjNeS1TDN_4ihA_Q-1; Mon, 04 Apr 2022 06:53:24 -0400
X-MC-Unique: TgDyIROjNeS1TDN_4ihA_Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6B7EA3C01B86;
 Mon,  4 Apr 2022 10:53:23 +0000 (UTC)
Received: from [10.72.12.126] (ovpn-12-126.pek2.redhat.com [10.72.12.126])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B62AC584FA;
 Mon,  4 Apr 2022 10:53:15 +0000 (UTC)
Subject: Re: [PATCH v6 00/18] Support SDEI Virtualization
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <a3bf5b44-0ab8-fd85-5557-6c496fd68bc1@redhat.com>
 <YkqLtYquZQAKjbAk@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <6f9b7597-f559-8218-a3ea-12da37c4c10f@redhat.com>
Date: Mon, 4 Apr 2022 18:53:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YkqLtYquZQAKjbAk@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Oliver,

On 4/4/22 2:09 PM, Oliver Upton wrote:
> On Sun, Apr 03, 2022 at 11:47:07PM +0800, Gavin Shan wrote:
>> I'm explicitly copying Oliver, James, Mark and Shannon to avoid resending this series.
>> It seems they have been skipped even I explicitly copied them by 'git send-email --cc=<email-addr>'.
> 
> Dunno about others, but FWIW your first crack at sending this series out
> arrived in my inbox just fine :)
> 
> Thanks for cc'ing me, I'll find some time this week to take a look.
> 

Thanks for letting me know the emails and patches have been delivered
correctly. Please take your time to review and thanks for your comments
again :)

Thanks,
Gavin


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
