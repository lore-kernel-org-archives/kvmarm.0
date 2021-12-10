Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B596C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 14:53:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B995E4B1E7;
	Fri, 10 Dec 2021 09:53:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nmsGIwxbEVuA; Fri, 10 Dec 2021 09:53:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B0CFD4B1FB;
	Fri, 10 Dec 2021 09:53:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B51814B1E4
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 09:53:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 91pq5wGW7gbU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 09:53:18 -0500 (EST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com
 [209.85.208.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61D894B1C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 09:53:18 -0500 (EST)
Received: by mail-ed1-f48.google.com with SMTP id x10so13437730edd.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 06:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=ZPopxfZRkg4NTOl+klIySl5FTmEnEGA7/rHJVRlm4p0=;
 b=axcBhrYY5F+b/7Id5o19CVMf16DlNK++Iv+QQkzI9Mnf7ZTRnJCaH9XidNQOFsOBwc
 KF/wXTKGrFlcXFR9QcXh0tmfQaqluH4DlsgXOrJpdK/LJQrYRJUCa1eRc6to96/IwV2B
 BlyqvjvgggseyLJ8qtFA8u7nkulUxlTbfdET3/IxAhjbM4n3l7+In1S5EkRZyqGZl5Ck
 wKgANnRzx+uuEJWvWG98rzsSbQ650jB+d4dvhyUIs42e58MDzXi1cDPbfAvmMlzdfpM0
 BOcEFYO9Tm6j84wjCz2oTA6sCdsavxKcq1hTPn1dIX2c8ATBFG3sdm+KRLTm8NvOgy5R
 pgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=ZPopxfZRkg4NTOl+klIySl5FTmEnEGA7/rHJVRlm4p0=;
 b=zk7XFCBPkW5PLK692dtCZaZyzRoRsPOOKxnf6rjxZaevVF7+pwd/xly7SAGxq3LjjO
 FTAJfkLEeishmK/SN16d6LJMxa7DWOx/LB06a6G92u3X9FWghFhPdjssctYIl1cNsWtn
 qOG1qJytX8beI6DSdWE9/RlM2t9r60xfrmDso7EKaPftp/SkYGcZvOEZJGAg2uL/hNjh
 jiFNR9qcV+GE8R/dKFV9qK5eUcaDayslXR6t1EQ+n9J3gY8TIhYmBVvfTNEXEACuwj14
 v2GKJFVdjQSP1czvdtAECLnpb6OO3K+srF31mScBRRUhjGbsEvatXyoIciDFE/XrllcH
 rhkw==
X-Gm-Message-State: AOAM533q0Cklsm8NgqbDuKzfLBN5pukiQrVdD4y4hnc1gUwi2NItKTi8
 ayjS5+yNVTDOvlsPk8D61Puyq273C+Q=
X-Google-Smtp-Source: ABdhPJzHeROj3HC5Sukl5Uto4GX2p0nJsKAKZ5t4nooil+qkn+wpDmJamxHHNUoZnQ1//006tmFgjQ==
X-Received: by 2002:a50:e003:: with SMTP id e3mr38840536edl.374.1639147986203; 
 Fri, 10 Dec 2021 06:53:06 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe?
 ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
 by smtp.googlemail.com with ESMTPSA id
 yc24sm1573561ejb.104.2021.12.10.06.53.04
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 10 Dec 2021 06:53:05 -0800 (PST)
Message-ID: <2d864e94-1bae-4cc2-7242-676ef102398f@redhat.com>
Date: Fri, 10 Dec 2021 15:53:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v5 08/12] KVM: Reinstate gfn_to_pfn_cache with
 invalidation support
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm <kvm@vger.kernel.org>
References: <20211121125451.9489-1-dwmw2@infradead.org>
 <20211121125451.9489-9-dwmw2@infradead.org>
 <b1bacc6f-be56-4108-6e52-4315a021184b@redhat.com>
 <b614d9ae0fe7910cfa72eee0b4077776f8012e5f.camel@infradead.org>
 <6cb2cd57-16f3-d0ec-adf6-cb8fdcbae035@redhat.com>
 <5d0a68cd0d06884a2a58338aace811144990f8f5.camel@infradead.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <5d0a68cd0d06884a2a58338aace811144990f8f5.camel@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 butt3rflyh4ck <butterflyhuangxx@gmail.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 "vkuznets @ redhat . com" <vkuznets@redhat.com>, linuxppc-dev@lists.ozlabs.org
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

T24gMTIvMTAvMjEgMTM6MjUsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiBPbiBUaHUsIDIwMjEt
MTItMDkgYXQgMjM6MzQgKzAxMDAsIFBhb2xvIEJvbnppbmkgd3JvdGU6Cj4+Cj4+IENvbXBhcmVk
IHRvIHRoZSByZXZpZXcgaXQncyBtaXNzaW5nIHRoaXMgaHVuazoKPj4KPj4gQEAgLTI2NSw3ICsy
NjUsNyBAQCB2b2lkIGt2bV9nZm5fdG9fcGZuX2NhY2hlX3VubWFwKHN0cnVjdCBrdm0gKmt2bSwg
c3RydWN0IGdmbl90b19wZm5fY2FjaGUgKmdwYykKPj4KPj4gICAgICAgICAgZ3BjLT52YWxpZCA9
IGZhbHNlOwo+Pgo+PiAtICAgICAgIG9sZF9raHZhID0gZ3BjLT5raHZhOwo+PiArICAgICAgIG9s
ZF9raHZhID0gKHZvaWQgKikoKHVuc2lnbmVkIGxvbmcpZ3BjLT5raHZhICYgflBBR0VfTUFTSyk7
Cj4+ICAgICAgICAgIG9sZF9kaXJ0eSA9IGdwYy0+ZGlydHk7Cj4gCj4gRG8geW91IGtub3cgd2hh
dD8gSSBjb3VsZG4ndCBicmluZyBteXNlbGYgdG8gYWRkIHRoYXQgYSBzZWNvbmQgdGltZS4gSQo+
IG1hbmFnZWQgaXQgb25jZSwgYnV0IGl0IG1hZGUgbWUgc2FkLgo+IAo+IERpZCBpdCBsaWtlIHRo
aXMgaW5zdGVhZDoKPiAKPiAtICAgICAgIG9sZF9raHZhID0gZ3BjLT5raHZhOwo+ICsgICAgICAg
b2xkX2todmEgPSBncGMtPmtodmEgLSBvZmZzZXRfaW5fcGFnZShncGMtPmtodmEpOwoKVmVyeSBu
aWNlLCBhbmQgaXQgd291bGQgaGF2ZSBkZXNlcnZlZCBhIG1hY3JvIGluIGluY2x1ZGUvbGludXgg
aWYgdGhlcmUgCndhc24ndCBhIGRlY2VudCB3YXkgdG8gd3JpdGUgaXQuCgo+IEkgY2hlY2tlZCB0
aGF0IGZvciBtZSBhdCBsZWFzdCwgR0NDIGlzIGNsZXZlciBlbm91Z2ggdG8ganVzdCBkbyB0aGUK
PiBtYXNrLgo+IAo+ICAgICAgICAgIG9sZF9raHZhID0gZ3BjLT5raHZhIC0gb2Zmc2V0X2luX3Bh
Z2UoZ3BjLT5raHZhKTsKPiAgIDEzMTogICA0OCA4YiA0MyA3OCAgICAgICAgICAgICBtb3YgICAg
MHg3OCglcmJ4KSwlcmF4Cj4gICAxMzU6ICAgNDggMjUgMDAgZjAgZmYgZmYgICAgICAgYW5kICAg
ICQweGZmZmZmZmZmZmZmZmYwMDAsJXJheAo+IAo+IAo+IEkgc3RpbGwgZG9uJ3Qgc2VlIHRoZSBw
cmV2aW91cyBwYXRjaGVzIGluIGt2bS9uZXh0IOKAlCBpcyB0aGF0IGFuCj4gYXV0b21hdGljIHB1
c2ggYWZ0ZXIgdGVzdGluZyBoYXMgcGFzc2VkLCBvciBpcyB0aGUga2VybmVsLm9yZwo+IGluZnJh
c3RydWN0dXJlIGp1c3QgKnJlYWxseSogc2xvdz8KCk5vLCBpdCdzIG1lIHJlYWxseSB3YW50aW5n
IHRvIHNlbmQgb3V0IHRoZSAtcmM1IHB1bGwgcmVxdWVzdCBiZWZvcmUgdGhlIAp3ZWVrZW5kLiAg
SnVzdCB3YWl0IGZpdmUgbW9yZSBtaW51dGVzLgoKUGFvbG8KCj4gSSd2ZSBwdXNoZWQgYmFzZWQg
b24gdGhlIGN1cnJlbnRseS12aXNpYmxlIGt2bS9uZXh0IHRvCj4gaHR0cHM6Ly9naXQuaW5mcmFk
ZWFkLm9yZy91c2Vycy9kd213Mi9saW51eC5naXQvc2hvcnRsb2cvcmVmcy9oZWFkcy94ZW4tZXZ0
Y2huCj4gYW5kIGNhbiByZXNlbmQgd2hlbiB0aGUgdHJlZSBmaW5hbGx5IHN1cmZhY2VzLgo+IAoK
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1h
aWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
