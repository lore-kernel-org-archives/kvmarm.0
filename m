Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCEFEC49EA3
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 11:31:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4662C61462
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 11:31:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4662C61462
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB0314B0E5;
	Tue, 15 Jun 2021 07:31:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ribYBQOatMS6; Tue, 15 Jun 2021 07:31:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 85C064B0C3;
	Tue, 15 Jun 2021 07:31:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC6B34B0BF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 07:31:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1hsdBwyOJ0xD for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 07:31:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE1140821
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 07:31:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1623756676;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=aQ2nOAspl2AGDi9hsIXoVirS49xlNLfSm3ZVd3FKUiQ=;
 b=V82DZbveubcSsIiwIZDz6ctHABaVoWqBPZAL0FfNG1bV3tVMXdn+nK4bOIWM4cnDLQv9K6
 CDEdRKojsAN/h0R5S1GddXdv10jrXlVD4DvTCEtnXfvh5BDpuIQuAY0rw7Ce1vRz4NyVHN
 kqk0I1LCNdK1iNyzhV2Rnb7fvwNUq/g=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-exm-VOSKPBOVk6w333Buuw-1; Tue, 15 Jun 2021 07:31:14 -0400
X-MC-Unique: exm-VOSKPBOVk6w333Buuw-1
Received: by mail-ej1-f70.google.com with SMTP id
 b10-20020a170906194ab02903ea7d084cd3so4414839eje.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 04:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=aQ2nOAspl2AGDi9hsIXoVirS49xlNLfSm3ZVd3FKUiQ=;
 b=Fc4MxCRiYkQn2TUUmDd4Y6IbRpBeZOrNB/pan8yyjMwC6EZHpnPEtnp6SliBqk6Lfy
 ULkcAUAC/+LiB0kJ/QjlZZKtVm/UIJ8ZvRKMWzDkKlYT+6iHu4Mbd/aqrBrdsGMZVs5q
 jm/m6OnQuG3Gdvr+GEbF//OYUnasKDIWhS4Vw83vV+wz+I5MB8F0t4L2AFtPcomxY31u
 BM/0Va0EblnLPvNySYLvPpYi6Vklt0bTj/i35oRVqXCkuNS9DoYaaccV8TzhSM5Sk3XS
 HhgXFcrczssaMefcgMLF5haaw0++uuMPppXuVCu9a5jPNtq10EN7wEB0SHbMpsruG+4b
 h5ag==
X-Gm-Message-State: AOAM531D9a8w7Cj63QKQCV6QA09+ioFfQyurdy5s2ZhmDojvaungnkcx
 JobMcGyLPA0dvZL/+xnompEAE3h3rX1KNjSdwPH/AuzGtlq0GSZ7dX+CZ6DMsfBxXVdnN9kTdX9
 iuKWJfnglaQO6g6mDmd7ofVFF
X-Received: by 2002:a17:906:6ad0:: with SMTP id
 q16mr20563674ejs.286.1623756673695; 
 Tue, 15 Jun 2021 04:31:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzKlp02kMxK2rO+S69nIrAnTgSLt5X2p2XEkmw4RDKa1lrb0dqopq+Tz3VP4q2ZjtECG1DKNg==
X-Received: by 2002:a17:906:6ad0:: with SMTP id
 q16mr20563625ejs.286.1623756673461; 
 Tue, 15 Jun 2021 04:31:13 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id u21sm7110928eja.59.2021.06.15.04.31.10
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 15 Jun 2021 04:31:12 -0700 (PDT)
To: "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
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
 Paul Mackerras <paulus@ozlabs.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 Cornelia Huck <cohuck@redhat.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>,
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>,
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 David Matlack <dmatlack@google.com>, Ricardo Koller <ricarkol@google.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>, Fuad Tabba <tabba@google.com>
References: <20210614212155.1670777-1-jingzhangos@google.com>
 <b86aa6df-5fd7-d705-1688-4d325df6f7d9@metux.net>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v9 0/5] KVM statistics data fd-based binary interface
Message-ID: <ad7905f9-8338-382a-b1df-9b3352bbd2f8@redhat.com>
Date: Tue, 15 Jun 2021 13:31:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b86aa6df-5fd7-d705-1688-4d325df6f7d9@metux.net>
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

T24gMTUvMDYvMjEgMTA6MzcsIEVucmljbyBXZWlnZWx0LCBtZXR1eCBJVCBjb25zdWx0IHdyb3Rl
Ogo+ICogd2h5IGlzIGl0IGJpbmFyeSBpbnN0ZWFkIG9mIHRleHQgPyBpcyBpdCBzbyB2ZXJ5IGhp
Z2ggdm9sdW1lIHRoYXQKPiAgwqAgaXQgcmVhbGx5IG1hdHRlcnMgPwoKVGhlIG1haW4gcmVhc29u
IHRvIGhhdmUgYSBiaW5hcnkgZm9ybWF0IGlzIG5vdCB0aGUgaGlnaCB2b2x1bWUgYWN0dWFsbHkg
Cih0aG91Z2ggaXQgYWxzbyBoYXMgaXRzIHBhcnQpLiAgUmF0aGVyLCB3ZSB3b3VsZCByZWFsbHkg
bGlrZSB0byBpbmNsdWRlIAp0aGUgc2NoZW1hIHRvIG1ha2UgdGhlIHN0YXRpc3RpY3Mgc2VsZi1k
ZXNjcmliaW5nLiAgVGhpcyBpbmNsdWRlcyBzdHVmZiAKbGlrZSB3aGV0aGVyIHRoZSB1bml0IG9m
IG1lYXN1cmUgb2YgYSBzdGF0aXN0aWMgaXMgY2xvY2sgY3ljbGVzLCAKbmFub3NlY29uZHMsIHBh
Z2VzIG9yIHdoYXRub3Q7IGhhdmluZyB0aGlzIGtpbmQgb2YgaW5mb3JtYXRpb24gaW4gdGV4dCAK
bGVhZHMgdG8gYXdrd2FyZG5lc3MgaW4gdGhlIHBhcnNlcnMuICB0cmFjZS1jbWQgaXMgYW5vdGhl
ciBleGFtcGxlIHdoZXJlIAp0aGUgZGF0YSBjb25zaXN0cyBvZiBhIHNjaGVtYSBmb2xsb3dlZCBi
eSBiaW5hcnkgZGF0YS4KClRleHQgZm9ybWF0IGNvdWxkIGNlcnRhaW5seSBiZSBhZGRlZCBpZiB0
aGVyZSdzIGEgdXNlY2FzZSwgYnV0IGZvciAKZGV2ZWxvcGVyIHVzZSBkZWJ1Z2ZzIGlzIHVzdWFs
bHkgYSBzdWl0YWJsZSByZXBsYWNlbWVudC4KCkxhc3QgeWVhciB3ZSB0cmllZCB0aGUgb3Bwb3Np
dGUgZGlyZWN0aW9uOiB3ZSBidWlsdCBhIG9uZS12YWx1ZS1wZXItZmlsZSAKZmlsZXN5c3RlbSB3
aXRoIGEgY29tbW9uIEFQSSB0aGF0IGFueSBzdWJzeXN0ZW0gY291bGQgdXNlIChlLmcuIApwcm92
aWRpbmcgZXRodG9vbCBzdGF0cywgL3Byb2MvaW50ZXJydXB0cywgZXRjLiBpbiBhZGRpdGlvbiB0
byBLVk0gCnN0YXRzKS4gIFdlIHN0YXJ0ZWQgd2l0aCB0ZXh0LCBzaW1pbGFyIHRvIHN5c2ZzLCB3
aXRoIHRoZSBwbGFuIG9mIApleHRlbmRpbmcgaXQgdG8gYSBiaW5hcnkgZm9ybWF0IGxhdGVyLiAg
SG93ZXZlciwgb3RoZXIgc3Vic3lzdGVtcyAKZXhwcmVzc2VkIHZlcnkgbGl0dGxlIGludGVyZXN0
IGluIHRoaXMsIHNvIGluc3RlYWQgd2UgZGVjaWRlZCB0byBnbyB3aXRoIApzb21ldGhpbmcgdGhh
dCBpcyBkZXNpZ25lZCBhcm91bmQgS1ZNIG5lZWRzLgoKU3RpbGwsIHRoZSBiaW5hcnkgZm9ybWF0
IHRoYXQgS1ZNIHVzZXMgaXMgZGVzaWduZWQgbm90IHRvIGJlIApLVk0tc3BlY2lmaWMuICBJZiBv
dGhlciBzdWJzeXN0ZW1zIHdhbnQgdG8gcHVibGlzaCBoaWdoLXZvbHVtZSwgCnNlbGYtZGVzY3Jp
YmluZyBzdGF0aXN0aWMgaW5mb3JtYXRpb24sIHRoZXkgYXJlIHdlbGNvbWUgdG8gc2hhcmUgdGhl
IApiaW5hcnkgZm9ybWF0IGFuZCB0aGUgY29kZS4gIFBlcmhhcHMgaXQgbWF5IG1ha2Ugc2Vuc2Ug
aW4gc29tZSBjYXNlcyB0byAKaGF2ZSB0aGVtIGluIHN5c2ZzLCBldmVuIChlLmcuIC9zeXMva2Vy
bmVsL3NsYWIvKi8uc3RhdHMpLiAgQXMgR3JlZyBzYWlkIApzeXNmcyBpcyBjdXJyZW50bHkgb25l
IHZhbHVlIHBlciBmaWxlLCBidXQgcGVyaGFwcyB0aGF0IGNvdWxkIGJlIGNoYW5nZWQgCmlmIHRo
ZSBiaW5hcnkgZm9ybWF0IGlzIGFuIGFkZGl0aW9uYWwgd2F5IHRvIGFjY2VzcyB0aGUgaW5mb3Jt
YXRpb24gYW5kIApub3QgdGhlIG9ubHkgb25lIChub3QgdGhhdCBJJ20gcGxhbm5pbmcgdG8gZG8g
aXQpLgoKPiAqIGhvdyB3aWxsIHBvc3NpYmxlIGZ1dHVyZSBleHRlbnNpb25zIG9mIHRoZSB0ZWxl
bWV0cnkgcGFja2V0cyB3b3JrID8KClRoZSBmb3JtYXQgaW5jbHVkZXMgYSBzY2hlbWEsIHNvIGl0
J3MgcG9zc2libGUgdG8gYWRkIG1vcmUgc3RhdGlzdGljcyBpbiAKdGhlIGZ1dHVyZS4gIFRoZSBl
eGFjdCBsaXN0IG9mIHN0YXRpc3RpY3MgdmFyaWVzIHBlciBhcmNoaXRlY3R1cmUgYW5kIGlzIApu
b3QgcGFydCBvZiB0aGUgdXNlcnNwYWNlIEFQSSAob2J2aW91cyBjYXZlYXQ6IGh0dHBzOi8veGtj
ZC5jb20vMTE3Mi8pLgoKPiAqIGFyZW4ndCB0aGVyZSBvdGhlciBtZWFucyB0byBnZXQgdGhpcyBm
ZCBpbnN0ZWFkIG9mIGFuIGlvY3RsKCkgb24gdGhlCj4gIMKgIFZNIGZkID8gc29tZXRoaW5nIG1v
cmUgZnJvbSB0aGUgb3V0c2lkZSAoZWcuIHN5c2ZzL3Byb2NmcykKCk5vdCB5ZXQsIGJ1dCBpZiB0
aGVyZSdzIGEgbmVlZCBpdCBjYW4gYmUgYWRkZWQuICBJdCdkIGJlIHBsYXVzaWJsZSB0byAKcHVi
bGlzaCBzeXN0ZW0td2lkZSBzdGF0aXN0aWNzIHZpYSBhIGlvY3RsIG9uIC9kZXYva3ZtLCBmb3Ig
ZXhhbXBsZS4gCldlJ2QgaGF2ZSB0byBjaGVjayBob3cgdGhpcyBjb21wYXJlcyB3aXRoIHN0dWZm
IHRoYXQgaXMgd29ybGQtcmVhZGFibGUgCmluIHByb2NmcyBhbmQgc3lzZnMsIGJ1dCBJIGRvbid0
IHRoaW5rIHRoZXJlIGFyZSBzZWN1cml0eSBjb25jZXJucyBpbiAKZXhwb3NpbmcgdGhhdC4KClRo
ZXJlJ3MgYWxzbyBwaWRmZF9nZXRmZCgyKSB3aGljaCBjYW4gYmUgdXNlZCB0byBwdWxsIGEgVk0g
ZmlsZSAKZGVzY3JpcHRvciBmcm9tIGFub3RoZXIgcnVubmluZyBwcm9jZXNzLiAgVGhhdCBjYW4g
YmUgdXNlZCB0byBhdm9pZCB0aGUgCmlzc3VlIG9mIEtWTSBmaWxlIGRlc2NyaXB0b3JzIGJlaW5n
IHVubmFtZWQuCgo+ICogaG93IHdpbGwgdGhhdCByZWxhdGUgdG8gb3RoZXIgaHlwZXJ2aXNvcnMg
PwoKT3RoZXIgaHlwZXJ2aXNvcnMgZG8gbm90IHJ1biBhcyBwYXJ0IG9mIHRoZSBMaW51eCBrZXJu
ZWwgKGF0IGxlYXN0IHRoZXkgCmFyZSBub3QgdXBzdHJlYW0pLiAgVGhlc2Ugc3RhdGlzdGljcyBv
bmx5IGFwcGx5IHRvIExpbnV4ICpob3N0cyosIG5vdCAKZ3Vlc3RzLgoKQXMgZmFyIGFzIEkga25v
dywgdGhlcmUgaXMgbm8gc3RhbmRhcmQgdGhhdCBYZW4gb3IgdGhlIHByb3ByaWV0YXJ5IApoeXBl
cnZpc29ycyB1c2UgdG8gY29tbXVuaWNhdGUgdGhlaXIgdGVsZW1ldHJ5IGluZm8gdG8gbW9uaXRv
cmluZyB0b29scywgCmFuZCBhbHNvIG5vIHN0YW5kYXJkIGJpbmFyeSBmb3JtYXQgdXNlZCBieSBl
eHBvcnRlcnMgdG8gdGFsayB0byAKbW9uaXRvcmluZyB0b29scy4gIElmIHRoaXMgZm9ybWF0IHdp
bGwgYmUgYWRvcHRlZCBieSBvdGhlciBoeXBlcnZpc29ycyAKb3IgYW55IHJhbmRvbSBzb2Z0d2Fy
ZSwgSSB3aWxsIGJlIGhhcHB5LgoKPiBTb21lIG5vdGVzIGZyb20gdGhlIG9wZXJhdGluZyBwZXJz
cGVjdGl2ZToKPiAKPiBJbiB0eXBpY2FsIGRhdGFjZW50ZXJzIHdlJ3ZlIGdvdCB2YXJpb3VzIG1v
bml0b3JpbmcgdG9vbHMgdGhhdCBhcmUgYWJsZQo+IHRvIGNhdGNoIHVwIGxvdHMgb2YgZGF0YSBm
cm9tIGRpZmZlcmVudCBzb3VyY2VzIChlc3BlY2lhbGx5IGZpbGVzKS4gSWYKPiBhbiBvcGVyYXRv
ciBlLmcuIGlzIGludGVyZXN0ZWQgaW4gc29tZXRoaW5nIGluIGhhcHBlbmluZyBpbiBzb21lIGZp
bGUKPiAoZS5nLiBpbiAvcHJvYyBvZiAvc3lzKSwgaXQncyBxdWl0ZSB0cml2aWFsIC0ganVzdCBj
b25maWd1cmUgeWV0IGFub3RoZXIKPiBwcm9iZSAobWF5YmUgc29tZSByZWdleCBmb3IgcGFyc2lu
ZykgYW5kIGRvbmUuIEF1dG9tYXRpY2FsbHkgZmVkIGluIGhpcwo+ICRtb25pdG9yaW5nX3NvbHV0
aW9uIChlLmcuIG5hZ2lvcywgRUxLLCBTcGx1bmssIHdoYXRzbm90KQoKLi4uIGJ1dCBpbiBwcmFj
dGljZSB3aGF0IHlvdSBkbyBpcyB5b3UgaGF2ZSBwcmVidWlsdCBleHBvcnRlcnMgdGhhdCAKdGFs
a3MgdG8gJG1vbml0b3Jpbmdfc29sdXRpb24uICBNb25pdG9yaW5nIGluZGl2aWR1YWwgZmlsZXMg
aXMgdGhlIApleGNlcHRpb24sIG5vdCB0aGUgcnVsZS4gIEJ1dCBpbmRlZWQgTGlidmlydCBhbHJl
YWR5IGhhcyBJL08gYW5kIG5ldHdvcmsgCnN0YXRpc3RpY3MgYW5kIHRoZXJlIGlzIGFuIGV4cG9y
dGVyIGZvciBQcm9tZXRoZXVzLCBzbyB3ZSBzaG91bGQgYWRkIApzdXBwb3J0IGZvciB0aGlzIG5l
dyBtZXRob2QgYXMgd2VsbCB0byBib3RoIFFFTVUgKGV4cG9ydGluZyB0aGUgZmlsZSAKZGVzY3Jp
cHRvcikgYW5kIExpYnZpcnQuCgpJIGhvcGUgdGhpcyBoZWxwcyBjbGFyaWZ5aW5nIHlvdXIgZG91
YnRzIQoKUGFvbG8KCj4gV2l0aCB5b3VyIGFwcHJvYWNoLCBpdCdzIG5vdCB0aGF0IHNpbXBsZTog
bm93IHRoZSBvcGVyYXRvciBuZWVkcyB0bwo+IGNyZWF0ZSAoYW5kIGRlcGxveSBhbmQgbWFuYWdl
KSBhIHNlcGFyYXRlIGFnZW50IHRoYXQgc29tZWhvdyByZWNlaXZlcwo+IHRoYXQgZmQgZnJvbSB0
aGUgVk1NLCByZWFkcyBhbmQgcGFyc2VzIHRoYXQgc3BlY2lmaWMgYmluYXJ5IHN0cmVhbQo+IGFu
ZCBmaW5hbGx5IHB1c2hlcyBpdCBpbnRvIHRoZSBtb25pdG9yaW5nIGluZnJhc3RydWN0dXJlLiBP
ciB0aGUgVk1NCj4gd3JpdGVzIGl0IGludG8gc29tZSBmaWxlLCB3aGVyZSBzb21lIG1vbml0b3Jp
bmcgYWdlbnQgY2FuIHBpY2sgaXQgdXAuCj4gSW4gYW55IGNhc2UsIG5vdCBhY3R1YWxseSB0cml2
aWFsIGZyb20gb3BzIHBlcnNwZWN0aXZlLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29s
dW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8v
a3ZtYXJtCg==
