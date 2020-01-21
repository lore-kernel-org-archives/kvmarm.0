Return-Path: <SRS0=DlSC=3K=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92555C2D0DB
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 15:10:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1874B20678
	for <kvmarm@archiver.kernel.org>; Tue, 21 Jan 2020 15:10:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPeo90f6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1874B20678
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A5AA4B01C;
	Tue, 21 Jan 2020 10:10:46 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b7gt1Yo0u85o; Tue, 21 Jan 2020 10:10:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0DE54B01D;
	Tue, 21 Jan 2020 10:10:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26E0E4B00C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 10:10:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3pJ11-dVvuG2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Jan 2020 10:10:35 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 280004B00A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 10:10:35 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1579619435;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=l3UImGOzBXgoozBAyoISgB2Kd4SVsoekGjPkkvWBCTg=;
 b=IPeo90f6Q8AaXVZgFJZocH325OqKjlRuUrA3621wg93Q3QRAGyBJLb2zLWsIhz8nYj+1uf
 shzMnuBQNoUlO/Raictb0y+OvTzQGtHX7YF+4jmzxpMpNvw3vAYQjoj55Bsz+U2t9uWqUk
 t8OOei/i3vhd3B4k4iimdP9AtAX8qZI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-BhY5qv7_OSKgvVwdT-BEnA-1; Tue, 21 Jan 2020 10:10:33 -0500
Received: by mail-wr1-f71.google.com with SMTP id y7so1446139wrm.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Jan 2020 07:10:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=dLNqv137Ty3zBX/5Bsp+2Ypr44jpbB2i9ogizbwLSF8=;
 b=O1s8De/Jn+OWKMNFhBiVLSPXxj7PP2NtPsQ1AUbTsYwWSn9F/zltpZywUWavykeLYr
 BmeC3zUS+2qMjaC+FIy5pUBYZls1wJKs4AtlR9l+QV7W+wNWU7S4n6tEqes0wXE8UL61
 JXvt98rDrrKLWem2eoJsBLyxpRmDCJ+FwOpQ4y5gT/4IsTHn9njbVQfn6hFRCQLzTiV9
 FGud0g3J34gF5HeLtkN+DrKUHzCwMQmr6tIm8y0+rPR5iffA1DFfPz0LIcWic2tdWVqR
 sBbuS6qhU3QYsOawKwXiXQG9Zhl/xbtEevEfyMc7Q+Vgu7xx5NUukd57aY93ucd+nWLy
 npjA==
X-Gm-Message-State: APjAAAUNbxLqlcZRUKDeqLcHnigxDCDD5gCsjLQPfGuye4/c7+lFRfjy
 sZwh3EKgnQeweaYtp8Kiayfm56yCg+BWOEDrx88HWhMYEV075FnYih0zdek0DOHcXkJBGMKtzrX
 FZchgGBAFx+KBGCMPFLvTZZr0
X-Received: by 2002:a5d:484d:: with SMTP id n13mr5658186wrs.420.1579619431916; 
 Tue, 21 Jan 2020 07:10:31 -0800 (PST)
X-Google-Smtp-Source: APXvYqxxEyxfwVY/ROHiQo6nFEJMG0NaKySaBG+B/YnTEdUCo5yvn8VFW7mI2ukJg01QncMPDMI9zQ==
X-Received: by 2002:a5d:484d:: with SMTP id n13mr5658133wrs.420.1579619431579; 
 Tue, 21 Jan 2020 07:10:31 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a?
 ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
 by smtp.gmail.com with ESMTPSA id h2sm53828069wrv.66.2020.01.21.07.10.30
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 21 Jan 2020 07:10:31 -0800 (PST)
Subject: Re: [PATCH 00/14] KVM: x86/mmu: Huge page fixes, cleanup, and DAX
To: Barret Rhoden <brho@google.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200108202448.9669-1-sean.j.christopherson@intel.com>
 <e3e12d17-32e4-84ad-94da-91095d999238@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d7d0801b-79be-a5e7-a376-abd92b5c09b2@redhat.com>
Date: Tue, 21 Jan 2020 16:10:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <e3e12d17-32e4-84ad-94da-91095d999238@google.com>
Content-Language: en-US
X-MC-Unique: BhY5qv7_OSKgvVwdT-BEnA-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Paul Mackerras <paulus@ozlabs.org>,
 linux-mm@kvack.org, kvmarm@lists.cs.columbia.edu,
 Dave Jiang <dave.jiang@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>,
 Marc Zyngier <maz@kernel.org>, Joerg Roedel <joro@8bytes.org>,
 syzbot+c9d1fb51ac9d0d10c39d@syzkaller.appspotmail.com, kvm-ppc@vger.kernel.org,
 Liran Alon <liran.alon@oracle.com>, Andy Lutomirski <luto@kernel.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 linux-kernel@vger.kernel.org, Jason Zeng <jason.zeng@intel.com>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMDkvMDEvMjAgMjA6NDcsIEJhcnJldCBSaG9kZW4gd3JvdGU6Cj4gSGkgLQo+IAo+IE9uIDEv
OC8yMCAzOjI0IFBNLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOgo+PiBUaGlzIHNlcmllcyBp
cyBhIG1peCBvZiBidWcgZml4ZXMsIGNsZWFudXAgYW5kIG5ldyBzdXBwb3J0IGluIEtWTSdzCj4+
IGhhbmRsaW5nIG9mIGh1Z2UgcGFnZXMuwqAgVGhlIHNlcmllcyBpbml0aWFsbHkgc3RlbW1lZCBm
cm9tIGEgc3l6a2FsbGVyCj4+IGJ1ZyByZXBvcnRbMV0sIHdoaWNoIGlzIGZpeGVkIGJ5IHBhdGNo
IDAyLCAibW06IHRocDogS1ZNOiBFeHBsaWNpdGx5Cj4+IGNoZWNrIGZvciBUSFAgd2hlbiBwb3B1
bGF0aW5nIHNlY29uZGFyeSBNTVUiLgo+Pgo+PiBXaGlsZSBpbnZlc3RpZ2F0aW5nIG9wdGlvbnMg
Zm9yIGZpeGluZyB0aGUgc3l6a2FsbGVyIGJ1ZywgSSByZWFsaXplZCBLVk0KPj4gY291bGQgcmV1
c2UgdGhlIGFwcHJvYWNoIGZyb20gQmFycmV0J3Mgc2VyaWVzIHRvIGVuYWJsZSBodWdlIHBhZ2Vz
IGZvcgo+PiBEQVgKPj4gbWFwcGluZ3MgaW4gS1ZNWzJdIGZvciBhbGwgdHlwZXMgb2YgaHVnZSBt
YXBwaW5ncywgaS5lLiB3YWxrIHRoZSBob3N0Cj4+IHBhZ2UKPj4gdGFibGVzIGluc3RlYWQgb2Yg
cXVlcnlpbmcgbWV0YWRhdGEgKHBhdGNoZXMgMDUgLSAwOSkuCj4gCj4gVGhhbmtzLCBTZWFuLsKg
IEkgdGVzdGVkIHRoaXMgcGF0Y2ggc2VyaWVzIG91dCwgYW5kIGl0IHdvcmtzIGZvciBtZS4KPiAo
SHVnZSBLVk0gbWFwcGluZ3Mgb2YgYSBEQVggZmlsZSwgZXRjLikuCgpRdWV1ZWQsIHRoYW5rcy4K
ClBhb2xvCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwpr
dm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9s
aXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
