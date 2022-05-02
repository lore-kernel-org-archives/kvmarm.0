Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2EEC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  2 May 2022 06:20:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E081A49EF1;
	Mon,  2 May 2022 02:20:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mgfGUqfmZSOA; Mon,  2 May 2022 02:20:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98A7249EF2;
	Mon,  2 May 2022 02:20:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7830D49EEF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 02:20:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aNX1X+wM7lzj for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 May 2022 02:20:07 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4480649EED
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 May 2022 02:20:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1651472406;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cZZThdhRROTvuVV09GGb7zDPJE/vDXcJufVUbNP+IP0=;
 b=fJl+FqFZ/sPUOj04Vaga9AYwmhXMUkMXS2VXIrvMSRllaCcJDyoT4nM+NKa+9FW1JIZLEV
 49zPE68m+fam0Qdzr2/cl8sXQ6NJrP236MW1j5q04M6bi3WttT46PlJpDIie197KyjXCGJ
 0bKRpCJeUF8X0UC0jCy+uiN8MMOtqVU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-286-SkRvhGPvPaG0-OP_rM3sNA-1; Mon, 02 May 2022 02:19:40 -0400
X-MC-Unique: SkRvhGPvPaG0-OP_rM3sNA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0A287866DF4;
 Mon,  2 May 2022 06:19:40 +0000 (UTC)
Received: from [10.72.12.86] (ovpn-12-86.pek2.redhat.com [10.72.12.86])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 341C6C27E91;
 Mon,  2 May 2022 06:19:33 +0000 (UTC)
Subject: Re: [PATCH v6 13/18] KVM: arm64: Support
 SDEI_EVENT_{COMPLETE,COMPLETE_AND_RESUME} hypercall
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-14-gshan@redhat.com> <Ym4tzRL0iMxyumJe@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <ba094956-2e58-4913-527a-af79475ee949@redhat.com>
Date: Mon, 2 May 2022 14:19:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Ym4tzRL0iMxyumJe@google.com>
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

On 5/1/22 2:50 PM, Oliver Upton wrote:
> On Sun, Apr 03, 2022 at 11:39:06PM +0800, Gavin Shan wrote:
>> This supports SDEI_EVENT_{COMPLETE, COMPLETE_AND_RESUME} hypercall.
>> They are used by guest to notify the completion of event in its
>> handler. The previously interrupted or preempted context is restored
>> like below.
>>
>>     * x0 - x17, PC and PState are restored to what values we had in
>>       the interrupted or preempted context.
>>
>>     * If it's SDEI_EVENT_COMPLETE_AND_RESUME hypercall, IRQ exception
>>       is injected.
> 
> I don't think that's how COMPLETE_AND_RESUME works. The caller specifies an
> address at which it would like to begin execution within the client
> exception level.
> 
> SDEI spec suggests this behaves like a synchronous exception. DEN 0054C
> 5.2.2 'Event Resume Context' speaks more about how it is supposed to
> work.
> 

It's actually the linux convention. If the event handler, which was
specified in previous hypercall to EVENT_REGISTER, returns success,
the (linux) client calls into COMPLETE_AND_RESUME and the resume
address is specified with FIQ vector offset. More details can be
found from arch/arm64/kernel::sdei.c::do_sdei_event().

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
