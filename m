Return-Path: <SRS0=y8js=UK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B5CC4321A
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jun 2019 11:29:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7A1852089E
	for <kvmarm@archiver.kernel.org>; Tue, 11 Jun 2019 11:29:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A1852089E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D86694A4E1;
	Tue, 11 Jun 2019 07:29:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VSAhtj-UvdEb; Tue, 11 Jun 2019 07:29:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 811404A508;
	Tue, 11 Jun 2019 07:29:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BB0C4A4E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jun 2019 07:29:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HyUtPBHQOWau for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Jun 2019 07:29:47 -0400 (EDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com
 [209.85.221.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A3ACD4A4E1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jun 2019 07:29:47 -0400 (EDT)
Received: by mail-wr1-f41.google.com with SMTP id n4so12637984wrs.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Jun 2019 04:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=8qwW4QLFfBtKgDafCW+DM4bjjPQdr1v0w8rEMFQF8Nc=;
 b=HcTfq69eBg3z2TW0giURI6XZFgxObG9Q8V8equlCpu+NAl5+e87tAYInQB5cgrkOOa
 TzocHCN8Cel3alT86Bl29I3b+gkGmYbcZ8Sqg8fqAiNCsQg+g2FnkR5yzFQjHu57zOLg
 R46lRrRYBIK309j/gFDrnKogwIJcWxZHIkiwnH6edwMqMRY6GmWwqWERLMBVAizlp1BB
 jXLsyz7RmSjQyeVb1rsi9iMj+oU0g76GSd0mcj2wDRHVODAdU0NQ2MaRxeowtkSwGG4/
 e+8HlxIfKVbDM+pJUBNrS26iQvxu88hvu6L5w3XojKCpdYpOCtoRvMg/JMkL0OM9wjcS
 cV5w==
X-Gm-Message-State: APjAAAUoD2bUvvibVTBMrVha9r21ylfbz1+WWRZNhzipajLdWqG5QMSI
 cOVWmF9ebDDUAKMoN466YswsjSVcZ+I=
X-Google-Smtp-Source: APXvYqxRkhZhFVuzHilj+D+oNIN0jm/MbCPNStvK6j2mqgYSwuEvx4QZFVySkwECNpCx/N73T3wteA==
X-Received: by 2002:adf:e9cc:: with SMTP id l12mr1943923wrn.29.1560252586574; 
 Tue, 11 Jun 2019 04:29:46 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8cc3:8abd:4519:2cd6?
 ([2001:b07:6468:f312:8cc3:8abd:4519:2cd6])
 by smtp.gmail.com with ESMTPSA id n1sm13073990wrx.39.2019.06.11.04.29.45
 (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
 Tue, 11 Jun 2019 04:29:45 -0700 (PDT)
Subject: Re: Reference count on pages held in secondary MMUs
To: Christoffer Dall <christoffer.dall@arm.com>
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
 <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
 <20190611112158.GA5318@e113682-lin.lund.arm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb04c637-24a6-220e-e596-299be5b1c503@redhat.com>
Date: Tue, 11 Jun 2019 13:29:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190611112158.GA5318@e113682-lin.lund.arm.com>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 11/06/19 13:21, Christoffer Dall wrote:
>> If I understand correctly, I think the MMU notifier would not fire if
>> you took an actual reference; the page would be pinned in memory and
>> could not be swapped out.
>>
> That was my understanding too, but I can't find the code path that would
> support this theory.

Yeah, as Andrea said you could drop the reference in the invalidate
callback too.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
