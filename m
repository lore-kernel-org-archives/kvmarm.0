Return-Path: <SRS0=kHGs=7P=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8927AC433E0
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jun 2020 05:44:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0AB02206C3
	for <kvmarm@archiver.kernel.org>; Tue,  2 Jun 2020 05:44:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y63W1x+j"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0AB02206C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DC554B1A3;
	Tue,  2 Jun 2020 01:44:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iA2bwYwaZJDT; Tue,  2 Jun 2020 01:44:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33ADD4B0F2;
	Tue,  2 Jun 2020 01:44:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D87504B09E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2020 01:44:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lZRCyTuYTUDk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Jun 2020 01:44:53 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9E804B11E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Jun 2020 01:44:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1591076693;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=bCo6Hs1XvKVZ/we8zlozkhnglL2Do2YvAix/0i2LEXM=;
 b=Y63W1x+jPASWT5dLtyK5KW30WZOC1GJJa8JS06G1AQ8rd9SaB6n6Ba29gFHIC68LRk5XXy
 g2SJa4uKMislkCTuJGk9/GPoDTGc2xWNnWDPHhOddVLsi2p0XOogH+l+TXpAYJ5HKB7NQX
 3+qoljhYnpwtl7RXlXHVtH/zL1vE5d0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-1OLmskEZNhOBtfnAOikoPA-1; Tue, 02 Jun 2020 01:44:49 -0400
X-MC-Unique: 1OLmskEZNhOBtfnAOikoPA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40DBC835B40;
 Tue,  2 Jun 2020 05:44:48 +0000 (UTC)
Received: from localhost.localdomain (vpn2-54-70.bne.redhat.com [10.64.54.70])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8D7375D9C9;
 Tue,  2 Jun 2020 05:44:45 +0000 (UTC)
Subject: Re: [PATCH RFCv2 9/9] arm64: Support async page fault
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>
References: <20200508032919.52147-1-gshan@redhat.com>
 <20200508032919.52147-10-gshan@redhat.com>
 <81adf013-3de7-23e6-7648-8aec821b033c@redhat.com>
 <a6addc25-29af-3690-8392-efa5e8381e98@redhat.com>
 <8ab64c6a-582b-691d-79ab-21cdc0455cd3@redhat.com>
 <6a4a82a4-af01-98c2-c854-9199f55f7bd3@redhat.com>
 <6965aaf641a23fab64fbe2ceeb790272@kernel.org>
 <d0bfb944-b50a-608a-7dcc-5a409cdc4524@redhat.com>
 <4337cca152df47c93d96e092189a0e36@kernel.org>
 <5c72c597-732e-7dbf-d056-665674ec1792@redhat.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <fca52ea1-294a-6011-45f1-d0df30069800@redhat.com>
Date: Tue, 2 Jun 2020 15:44:42 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <5c72c597-732e-7dbf-d056-665674ec1792@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: catalin.marinas@arm.com, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 will@kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc, Paolo,

On 6/1/20 7:21 PM, Paolo Bonzini wrote:
> On 31/05/20 14:44, Marc Zyngier wrote:
>>>
>>> Is there an ARM-approved way to reuse the S2 fault syndromes to detect
>>> async page faults?
>>
>> It would mean being able to set an ESR_EL2 register value into ESR_EL1,
>> and there is nothing in the architecture that would allow that,
> 
> I understand that this is not what you want to do and I'm not proposing
> it, but I want to understand this better: _in practice_ do CPUs check
> closely what is written in ESR_EL1?
> 
> In any case, the only way to implement this, it seems to me, would be a
> completely paravirtualized exception vector that doesn't use ESR at all.
> 
> On the other hand, for the page ready (interrupt) side assigning a PPI
> seems complicated but doable.
> 

Marc suggested to use SDEI in another reply. I think it might be the
appropriate way to deliver page-not-present. To some extent, it could
be regarded as exception, which doesn't use ESR at all. It matches with
what Paolo is thinking of: paravirtualized exception vector that doesn't
use ESR at all. However, it seems it's not supported in kvm-arm yet. So
I assume it needs to be developed from scratch. Marc, could you please
help to confirm? Thanks in advance.

I agree with Paolo PPI (interrupt) might be the best way to deliver
page-ready currently. I don't think SDEI is suitable because there
are no big difference between SDEI and currently used DABT injection
to some extent. With SDEI, We will have the issues we are facing.
For example, some critical code section isn't safe to receive SDEI
if I'm correct.


Thanks,
Gavin

[...]

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
