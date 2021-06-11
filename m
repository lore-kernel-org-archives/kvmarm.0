Return-Path: <SRS0=JLBt=LF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32A41C48BD1
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 10:51:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E30A61357
	for <kvmarm@archiver.kernel.org>; Fri, 11 Jun 2021 10:51:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E30A61357
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17BFE4B0D8;
	Fri, 11 Jun 2021 06:51:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qs2TvL57UoOJ; Fri, 11 Jun 2021 06:51:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2051C4B0B4;
	Fri, 11 Jun 2021 06:51:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9869E4B09F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 06:51:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2kBTXyrnBkL3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Jun 2021 06:51:32 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9764D4A32E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 06:51:32 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623408692;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=GeF6NSmY+RlePXJwinqUloNFNozec5u88pDu1en91rg=;
 b=KpeTn3gpaEERDrSDFchXs8dtP/Pku5DSldb16Ko+ziOXD+sX1aqhZHS89WfteuHjzyBtX3
 ojGU5gEpH+JFbRx1lGIkK79O5zUlqr7xrYNVAmn6RMPB3sDyOmnuzKvWQVuE4lBimCNWXE
 R8Eh0W5cV72iAHaQD7Pg3xhKtaNpw1E=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-_H0XIi2zMuC1rdEu6uF_WA-1; Fri, 11 Jun 2021 06:51:29 -0400
X-MC-Unique: _H0XIi2zMuC1rdEu6uF_WA-1
Received: by mail-wr1-f72.google.com with SMTP id
 t14-20020adfe44e0000b029011851efa802so2430708wrm.11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Jun 2021 03:51:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=GeF6NSmY+RlePXJwinqUloNFNozec5u88pDu1en91rg=;
 b=ap7r4QLpyMG2ZUMXITUUnh8fDZJcjQbau9Q/h/HXheqHONkuKurtoULn8cBOPMTgEL
 nZrxdqfH4BRCpGFeec74tmNkn4Plg/AoFDcjtgvXybBNC7miVc+syTc7AGcJGTiLSELp
 ffUem4jgKAH8MbhLrxTm0//v8EPpGMW1jF30wXbpnbe0mktU2b+TACgfrvZjqUysvfi3
 Jdrgya6GGqcUTLyifQN7C584nHLnB/cQGjNf90EDwmi7USzZp1/BLoR8TqMkfCd9Ctzi
 LUld4dKGmebomaLfASTCd4pb7IqzgK3w3inmop8k3Qivky68YAh9/1jOMxlnEKjQ6DE9
 euUQ==
X-Gm-Message-State: AOAM53020lhSj5DI15kaFjgdu/fvfJig7YPNFITHInXMbMX9WCy3XFsw
 4/ZseD7EKYLyQFVo7PK3LDHQTDg+swFZn+byO6X5AnIUpIT1yYVpgroAuGnnAl1An08D7W1L/aM
 PEysVSrbcEzIfdCcxId112IxO
X-Received: by 2002:a5d:6c6d:: with SMTP id r13mr3313593wrz.350.1623408688106; 
 Fri, 11 Jun 2021 03:51:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwkNd9ko6ID8OBZPsEJA+MAlG7UkZ9Guko+3nwZmFCnop+c0VjyxH8jWHme4xipbMFJRZnG/w==
X-Received: by 2002:a5d:6c6d:: with SMTP id r13mr3313547wrz.350.1623408687852; 
 Fri, 11 Jun 2021 03:51:27 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id h9sm12694249wmm.33.2021.06.11.03.51.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 11 Jun 2021 03:51:27 -0700 (PDT)
To: Christian Borntraeger <borntraeger@de.ibm.com>,
 Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>, LinuxMIPS
 <linux-mips@vger.kernel.org>, KVMPPC <kvm-ppc@vger.kernel.org>,
 LinuxS390 <linux-s390@vger.kernel.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Will Deacon <will@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, Janosch Frank <frankja@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>
References: <20210603211426.790093-1-jingzhangos@google.com>
 <20210603211426.790093-2-jingzhangos@google.com>
 <03f3fa03-6f61-7864-4867-3dc332a9d6f3@de.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 1/4] KVM: stats: Separate generic stats from
 architecture specific ones
Message-ID: <bdd315f7-0615-af69-90c3-1e5646f3e259@redhat.com>
Date: Fri, 11 Jun 2021 12:51:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <03f3fa03-6f61-7864-4867-3dc332a9d6f3@de.ibm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
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
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMTEvMDYvMjEgMDg6NTcsIENocmlzdGlhbiBCb3JudHJhZWdlciB3cm90ZToKPj4gQEAgLTc1
NSwxMiArNzUwLDEyIEBAIHN0cnVjdCBrdm1fdmNwdV9hcmNoIHsKPj4gwqAgfTsKPj4gwqAgc3Ry
dWN0IGt2bV92bV9zdGF0IHsKPj4gK8KgwqDCoCBzdHJ1Y3Qga3ZtX3ZtX3N0YXRfZ2VuZXJpYyBn
ZW5lcmljOwo+IAo+IHMzOTAgZG9lcyBub3QgaGF2ZSByZW1vdGVfdGxiX2ZsdXNoLiBJIGd1ZXNz
IHRoaXMgZG9lcyBub3QgaHVydD8KCkl0IHdvdWxkIGhhdmUgdG8gYmUgYWNjb3VudGVkIGluIGdt
YXBfZmx1c2hfdGxiLCBidXQgdGhlcmUgaXMgbm8gc3RydWN0IAprdm0gaW4gdGhlcmUuICBBIHNs
aWdodGx5IGhhY2tpc2ggcG9zc2liaWxpdHkgd291bGQgYmUgdG8gaW5jbHVkZSB0aGUgCmdtYXAg
YnkgdmFsdWUgKGluc3RlYWQgb2YgYnkgcG9pbnRlcikgaW4gc3RydWN0IGt2bSwgYW5kIHRoZW4g
dXNlIApjb250YWluZXJfb2YuCgpUaGlzIHJlbWluZHMgbWUgdGhhdCBJIGhhdmUgbmV2ZXIgYXNr
ZWQgeW91IHdoeSB0aGUgZ21hcCBjb2RlIGlzIG5vdCBpbiAKYXJjaC9zMzkwL2t2bSwgYW5kIGFs
c28gdGhhdCB0aGVyZSBpcyBubyBjb2RlIGluIFFFTVUgdGhhdCB1c2VzIApLVk1fVk1fUzM5MF9V
Q09OVFJPTCBvciBLVk1fUzM5MF9WQ1BVX0ZBVUxULiAgSXQgd291bGQgYmUgbmljZSB0byBoYXZl
IApzb21lIHRlc3RjYXNlcyBmb3IgdGhhdCwgYW5kIGFsc28gZm9yIEtWTV9TMzkwX1ZDUFVfRkFV
TFQgd2l0aCByZWd1bGFyIAp2aXJ0dWFsIG1hY2hpbmVzLi4uIG9yIHRvIHJlbW92ZSB0aGUgY29k
ZSBpZiBpdCdzIHVudXNlZC4KClRoYW5rcywKClBhb2xvCgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
