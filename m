Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B3CC433FE
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 09:45:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B6766121F
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 09:44:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 9B6766121F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18EA54B0C0;
	Thu, 23 Sep 2021 05:44:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cOgaMPgG0kIq; Thu, 23 Sep 2021 05:44:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 29E364B11A;
	Thu, 23 Sep 2021 05:44:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FA614B0C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 05:44:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eT9VIn+baocg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 05:44:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABE774B0BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 05:44:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1632390296;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Op2qoA0X6Ury/zosiAJXrERLFd0OXj6FZBc06wzqmPc=;
 b=B2AOMBIx2iD1GXOzpT19Ku/fNVXKwazwKfbFG2Mu92fj/aR3BWGZEPJ0rn7yRifp6YHZFm
 ut+zOKgVoBSCIz/Q9urtZNyH0Fx9yKMhXXaCnHxcJSLFHrEnfx1MAxAJA9P3O6g+oYOnOK
 IO+E/shgXpTToSCuGO8eca77lAL8nKQ=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-rOlD_5QWPOOXsvtGZgCwgg-1; Thu, 23 Sep 2021 05:44:54 -0400
X-MC-Unique: rOlD_5QWPOOXsvtGZgCwgg-1
Received: by mail-ed1-f69.google.com with SMTP id
 a6-20020a50c306000000b003da30a380e1so1488290edb.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 02:44:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=Op2qoA0X6Ury/zosiAJXrERLFd0OXj6FZBc06wzqmPc=;
 b=CncP6qxcLwRM8qAyCY00hclS0k6APCsOtjjkQ12GyA9/XdNYcBJ7q3yXbZWZAf59uS
 WijTkbMcXp7Akt3BmY/lBqD2ctcM1h2YzqMIOBJeYUlsptMJIbaRjQ6N2qLYRtbE+s0v
 GDQzs89C5+Z4Orpm19haJejO30R3WjZ3+/QRCyb4J6BpKA1+4VS7GmfKPFEPLfX+fwsZ
 cncFzXV66xS9CEhDQgthb3SbsGUtu/9hZWucBg6gqlhCwGh4Yq+6cKjQcKv0HERLsGds
 pzc5gj1EuO7Mda3knbqICddhBG5121ABYPmGKUD11ja+UG2vmoLZtNEu0pryMLHTR7/Q
 7JIQ==
X-Gm-Message-State: AOAM530LeXsk3aMuv+3Pdrt/SJWto2gz74zSTD38rAoZ/pGiYOs9vddT
 JL/xx6FrnS9YikvjmktbdsyolUFa9rk9B3A4VQlkjsreDl6F9aEZ1sN6UCF1CoDKa0FetUoKViO
 6E7Bip6yKiBgUGYFi4lDoOJ9M
X-Received: by 2002:a50:d88a:: with SMTP id p10mr4332450edj.274.1632390293739; 
 Thu, 23 Sep 2021 02:44:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPCN0OqTken5jvVkYlVKwejgNBxL3gEDAFz0FGtJBhVhqwLaHEpc/KSsW/W8jn3S34zdGMNA==
X-Received: by 2002:a50:d88a:: with SMTP id p10mr4332419edj.274.1632390293499; 
 Thu, 23 Sep 2021 02:44:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id bj10sm2653827ejb.17.2021.09.23.02.44.50
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 23 Sep 2021 02:44:52 -0700 (PDT)
To: Marc Zyngier <maz@kernel.org>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
 <YUtyVEpMBityBBNl@google.com> <875yusv3vm.wl-maz@kernel.org>
 <a1e77794-de94-1fb7-c7d3-a80c34f770a4@redhat.com>
 <8735pvvip9.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
Message-ID: <2120a93b-2e15-117d-349c-9045cef23439@redhat.com>
Date: Thu, 23 Sep 2021 11:44:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8735pvvip9.wl-maz@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Aaron Lewis <aaronlewis@google.com>, KVM <kvm@vger.kernel.org>,
 Venkatesh Srinivas <venkateshs@google.com>, Peter Shier <pshier@google.com>,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
 Jim Mattson <jmattson@google.com>
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

On 23/09/21 09:45, Marc Zyngier wrote:
> On Thu, 23 Sep 2021 07:36:21 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 22/09/21 20:53, Marc Zyngier wrote:
>>> I definitely regret adding the current KVM trace points, as they
>>> don't show what I need, and I can't change them as they are ABI.
>>
>> I disagree that they are ABI.  And even if you don't want to change
>> them, you can always add parameters or remove them.
> 
> We'll have to agree to disagree here. Experience has told me that
> anything that gets exposed to userspace has to stay forever. There are
> countless examples of that on the arm64 side (cue the bogomips debate,
> the recent /proc/interrupts repainting).

Files certainly have the problem that there are countless ways to parse 
them, most of them wrong.  This for example was taken into account when 
designing the binary stats format, where it's clear that the only fixed 
format (ABI) is the description of the stats themselves.

However yeah, you're right that what constitutes an API is complicated. 
  Tracepoints and binary stats make it trivial to add stuff (including 
adding more info in the case of a tracepoint), but removing is tricky.

Another important aspect is whether there are at all any tools using the 
tracepoints.  In the case of the block subsystem there's blktrace, but 
KVM doesn't have anything fancy (tracing is really only used by humans 
via trace-cmd, or by kvmstat which doesn't care about which tracepoints 
are there).

> We had that discussion a few KSs ago (triggered by this[1] if I
> remember correctly), and I don't think anything has changed since.
> 
> As for removing them, that would probably be best for some (if not
> most) of them.

I'd say just go ahead.  System calls are removed every now and then if 
they are considered obsolete or a failed experiment.  Tracepoints are in 
the same boat.

Paolo

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
