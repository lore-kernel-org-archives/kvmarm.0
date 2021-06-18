Return-Path: <SRS0=A4hI=LM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD945C48BDF
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 16:09:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 168DF613B4
	for <kvmarm@archiver.kernel.org>; Fri, 18 Jun 2021 16:09:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 168DF613B4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gnu.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84FA94B080;
	Fri, 18 Jun 2021 12:09:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ig5p1Dmmw2wn; Fri, 18 Jun 2021 12:09:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DCC249DE7;
	Fri, 18 Jun 2021 12:09:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C53B4A4A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 11:51:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8DZlL1GVQGTv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Jun 2021 11:51:36 -0400 (EDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com
 [209.85.221.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1C0C2407F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 11:51:36 -0400 (EDT)
Received: by mail-wr1-f52.google.com with SMTP id y7so11230349wrh.7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Jun 2021 08:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:to:cc:references:from:subject:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=CD9XnXo3UlaYFvntUj461NFpsSCX2GWDOVULfKVOTy0=;
 b=nDc9H2/XnHo7s1BgDDoRt0U6v8ckmFqgmEWFtyKB3gfuFjOr7AP752I7pJacwMeuSn
 U/N4IaBNR+4GN8t3kdoNdZmWixER4cTnLJyqpxg5JCe/VumjOLB4qSraPZr409ZG3PZR
 0iX0k4yCHpfc85SqA80AbZrqtr9qe+aEXf6xYu+YT3n3aIR7jkhsSJ2AC8Rehe6CNfJO
 4ON9vNCZv3TbETMSsLGAyGhRJaZRjcAMvF6iZSQhEwrh5V/96XvHkN4F7tVugqqjzx4A
 hIB73eHqOfRDSbpcetHtIEFX+ecPZrlzSoUsDELCq6c6U7aMuqxznfJspBB+4rl5Qytn
 Juwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
 :date:user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=CD9XnXo3UlaYFvntUj461NFpsSCX2GWDOVULfKVOTy0=;
 b=PCPAtFL4ocyVacxtEVlpQ+BUVEphq0y8QHDL9l6VnYd4LZwFjE1wmIM8+dfQcmGyHO
 w+TDOwbbKnyZNPaDn1eNB3OZrnsZDlAZY1CPUmYYZ3Xus5kOzqlKOCgWD3t77KvncEEF
 7HaYOJIrDIeAz+Yh8kwZgzibrOcmfOVMvFElSnmDNMM2d7O/1bL2j3W1+BY7TwWgpKC+
 o87kFsSnl+f+7UrMkaZWsq6VzX/+qoANm7iO8R8w6hCVIJkCCn+jOuk6eF1uOnLEGtKW
 LaH8kPXm2AHH6+ZbzdiQ2Z5YZwp4VbnVjGkiVh882yWNjFEIrMWfD+LsjTdNdrD3O6j0
 GtzQ==
X-Gm-Message-State: AOAM533vqxys8BL74GzgY4/CZ7kiV2kqznp0nlGaTNOowIjsqwYh46eS
 T1j5tKTdugKKaPAXvMYRyFw=
X-Google-Smtp-Source: ABdhPJzkI7Io3g4FbXkpApW8iRbTya+G4og+TF5Olp6jNzTRurHJqUU5y/Ze/8I4kybjCv0/noZ/6A==
X-Received: by 2002:adf:f20c:: with SMTP id p12mr13048124wro.257.1624031495092; 
 Fri, 18 Jun 2021 08:51:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.googlemail.com with ESMTPSA id b8sm11568956wmd.35.2021.06.18.08.51.33
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 18 Jun 2021 08:51:34 -0700 (PDT)
To: Greg KH <gregkh@linuxfoundation.org>
References: <20210618044819.3690166-1-jingzhangos@google.com>
 <20210618044819.3690166-3-jingzhangos@google.com>
 <YMxEqvKyGnZinMOS@kroah.com> <f2616b8e-0cf8-570f-4bd3-7ef5cbcb37b0@gnu.org>
 <YMxYC8syYRBhbBAq@kroah.com>
From: Paolo Bonzini <bonzini@gnu.org>
Subject: Re: [PATCH v11 2/7] KVM: stats: Add fd-based API to read binary stats
 data
Message-ID: <22bb0eb6-1305-4af9-aecc-166d7e62e6c3@gnu.org>
Date: Fri, 18 Jun 2021 17:51:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMxYC8syYRBhbBAq@kroah.com>
Content-Language: en-US
X-Mailman-Approved-At: Fri, 18 Jun 2021 12:09:17 -0400
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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

On 18/06/21 10:23, Greg KH wrote:
> On Fri, Jun 18, 2021 at 10:02:57AM +0200, Paolo Bonzini wrote:
>> On 18/06/21 09:00, Greg KH wrote:
>>>> +struct kvm_stats_header {
>>>> +	__u32 name_size;
>>>> +	__u32 count;
>>>> +	__u32 desc_offset;
>>>> +	__u32 data_offset;
>>>> +	char id[];
>>>> +};
>>>
>>> You mentioned before that the size of this really is the size of the
>>> structure + KVM_STATS_ID_MAXLEN, right?  Or is it - KVM_STATS_ID_MAXLEN?
>>>
>>> If so, why not put that value explicitly in:
>>> 	char id[THE_REST_OF_THE_HEADER_SPACE];
>>>
>>> As this is not a variable header size at all, and you can not change it
>>> going forward, so the variable length array here feels disingenuous.
>>
>> It can change; the header goes up to desc_offset.  Let's rename desc_offset
>> to header_size.
> 
> "Traditionally" the first field of a variable length structure like this
> has the size.  So maybe this needs to be:
> 
> struct kvm_stats_header {
> 	__u32 header_size;

Thinking more about it, I slightly prefer id_offset so that we can later 
give a meaning to any bytes after kvm_stats_header and before id_offset.

Adding four unused bytes (for now always zero) is also useful to future 
proof the struct a bit, thus:

struct kvm_stats_header {
	__u32 flags;
	__u32 name_size;
	__u32 num_desc;
	__u32 id_offset;
	__u32 desc_offset;
	__u32 data_offset;
}

(Indeed num_desc is better than count).

> Wait, what is "name_size" here for?

So that you know the full size of the descriptors is (name_size + 
sizeof(kvm_stats_desc) + name_size) * num_desc.  That's the memory you 
allocate and the size that you can then pass to a single pread system 
call starting from offset desc_offset.

There is certainly room for improvement in that the length of id[] and 
name[] can be unified to name_size.

>>>> +struct kvm_stats_desc {
>>>> +	__u32 flags;
>>>> +	__s16 exponent;
>>>> +	__u16 size;
>>>> +	__u32 offset;
>>>> +	__u32 unused;
>>>> +	char name[];
>>>> +};
>>>
>>> What is the max length of name?
>>
>> It's name_size in the header.
> 
> So it's specified in the _previous_ header?  That feels wrong, shouldn't
> this descriptor define what is in it?

Compared to e.g. PCI where you can do random-access reads from memory or 
configuration space, reading from a file has slightly different 
tradeoffs.  So designing a file format is slightly different compared to 
designing an in-memory format, or a wire protocol.

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
