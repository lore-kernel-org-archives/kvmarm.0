Return-Path: <SRS0=+5+0=QF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA341C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:40:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4D52B61AA3
	for <kvmarm@archiver.kernel.org>; Thu, 18 Nov 2021 18:40:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4D52B61AA3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1DE84B17D;
	Thu, 18 Nov 2021 13:40:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BbsB93YL5+jt; Thu, 18 Nov 2021 13:40:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABC584ACC9;
	Thu, 18 Nov 2021 13:40:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB6864ACC9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:40:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6RykxuhN-Yxk for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Nov 2021 13:40:52 -0500 (EST)
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com
 [209.85.214.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 99DEA4A4BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 13:40:52 -0500 (EST)
Received: by mail-pl1-f175.google.com with SMTP id q17so6004361plr.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Nov 2021 10:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=grrMnij3a2kLK2nD9/+zi8H0lxQV5j7EQVRD7AIwS2E=;
 b=DnjI9osT+moWRQdwwunhhgYe2YGuzWKrQy5JwjvEJNUqQcpvnb0WoX5Pei6uXI5OdC
 7eGLhv3YIzk62P6sC5D7JBPnUohj6O7s664U/+jqNIv857J2ijyYc9lxkutY0si+1Jso
 ztfH/9rMsVdRRal+62dCEzvALKr3rtl5XahGBeHA8m4ynGczBHkUGlN7RYWuUfQGcFke
 WSfMnan0Kg6M9yWEVCFKWFu1Oy/he0ioyfZD1myK/YDRWIUpBN/5hc73yoNPRxPOyT9C
 VLzYMyPNfdN9orn15Wn6MlOWGc4Qs8aD/O0pRMiPP4mF4KE17PRSHz5sCFRZguQ3AWZA
 KcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=grrMnij3a2kLK2nD9/+zi8H0lxQV5j7EQVRD7AIwS2E=;
 b=rhpB6k1LEjUfiOGjb/5Ur5xt7rqE1nKTxrLAEVIo5/bnjN7YqQIZyEQG29RvHZbWba
 p8WqVF71Qs82mL+O8dUmrUH58Mzd9g3AZ41iBR6YKsZOhYAKJ7Ph6OSFu5Cudzxx3qJd
 igpKV6JgfDe9eXepRlTqJ0irq5vpuzgOfMEB0rwCsiwytAvG9alWZh9ksMbeq6UhfdYo
 CNo6TTvoGKDU5sLcR0gdWnPx9e6G1cIsj/kZzh97l88T+dAZ76ULyTBYiwggdkWi5aou
 HoYHCMX6rvY9ynwXrvJRwT8P16LkC//xNvWs8wiC8nCJ6vo9brwn5UrZPqq/UPrNHeTn
 2bBA==
X-Gm-Message-State: AOAM533RD+nYdC602JY/xmemh2uQdMHeiZH3829jLAMXDZg1+fXzviqr
 O0yFHhYcvlSI6YKL07EvvA5pbQ==
X-Google-Smtp-Source: ABdhPJxTT+sS2hBA2CisuiyQO1bWgOM4L3odX2TF09Y4yJcQHjhUg5+FNsR41T/1dQnqfraxxzIiPQ==
X-Received: by 2002:a17:90a:af94:: with SMTP id
 w20mr12506911pjq.223.1637260851435; 
 Thu, 18 Nov 2021 10:40:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com.
 [35.185.214.157])
 by smtp.gmail.com with ESMTPSA id a12sm8600266pjq.16.2021.11.18.10.40.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 18 Nov 2021 10:40:50 -0800 (PST)
Date: Thu, 18 Nov 2021 18:40:47 +0000
From: Sean Christopherson <seanjc@google.com>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v3 08/12] KVM: Propagate vcpu explicitly to
 mark_page_dirty_in_slot()
Message-ID: <YZaeL5YztL3p1nLM@google.com>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org>
 <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
 <4c48546b-eb4a-dff7-cc38-5df54f73f5d4@redhat.com>
 <20b5952e76c54a3a5dfe5a898e3b835404ac6fb1.camel@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20b5952e76c54a3a5dfe5a898e3b835404ac6fb1.camel@infradead.org>
Cc: Anup Patel <anup.patel@wdc.com>,
 "wanpengli @ tencent . com" <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>,
 Joao Martins <joao.m.martins@oracle.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, linux-s390@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, "joro @ 8bytes . org" <joro@8bytes.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, karahmed@amazon.com,
 Catalin Marinas <catalin.marinas@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 "jmattson @ google . com" <jmattson@google.com>,
 "mtosatti @ redhat . com" <mtosatti@redhat.com>, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
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
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gVGh1LCBOb3YgMTgsIDIwMjEsIERhdmlkIFdvb2Rob3VzZSB3cm90ZToKPiBUaGF0IGxlYXZl
cyB0aGUgb25lIGluIFREUCBNTVUgaGFuZGxlX2NoYW5nZWRfc3B0ZV9kaXJ0eV9sb2coKSB3aGlj
aAo+IEFGQUlDVCBjYW4gdHJpZ2dlciB0aGUgc2FtZSBjcmFzaCBzZWVuIGJ5IGJ1dHQzcmZseWg0
Y2sg4oCUIGNhbid0IHRoYXQKPiBoYXBwZW4gZnJvbSBhIHRocmVhZCB3aGVyZSBrdm1fZ2V0X3J1
bm5pbmdfdmNwdSgpIGlzIE5VTEwgdG9vPyBGb3IgdGhhdAo+IG9uZSBJJ20gbm90IHN1cmUuCgpJ
IHRoaW5rIGNvdWxkIGJlIHRyaWdnZXIgaW4gdGhlIFREUCBNTVUgdmlhIGt2bV9tbXVfbm90aWZp
ZXJfcmVsZWFzZSgpCi0+IGt2bV9tbXVfemFwX2FsbCgpLCBlLmcuIGlmIHRoZSB1c2Vyc3BhY2Ug
Vk1NIGV4aXRzIHdoaWxlIGRpcnR5IGxvZ2dpbmcgaXMKZW5hYmxlZC4gIFRoYXQgc2hvdWxkIGJl
IGVhc3kgdG8gKGRpcylwcm92ZSB2aWEgYSBzZWxmdGVzdC4KCkFuZCBmb3IgdGhlIHJlY29yZCA6
LSkKCk9uIE1vbiwgRGVjIDAyLCAyMDE5IGF0IDEyOjEwOjM2UE0gLTA4MDAsIFNlYW4gQ2hyaXN0
b3BoZXJzb24gd3JvdGU6Cj4gSU1PLCBhZGRpbmcga3ZtX2dldF9ydW5uaW5nX3ZjcHUoKSBpcyBh
IGhhY2sgdGhhdCBpcyBqdXN0IGFza2luZyBmb3IgZnV0dXJlCj4gYWJ1c2UgYW5kIHRoZSB2Y3B1
L3ZtL2FzX2lkIGludGVyYWN0aW9ucyBpbiBtYXJrX3BhZ2VfZGlydHlfaW5fcmluZygpCj4gbG9v
ayBleHRyZW1lbHkgZnJhZ2lsZS4KCk9uIDAzLzEyLzE5IDIwOjAxLCBTZWFuIENocmlzdG9waGVy
c29uIHdyb3RlOgo+IEluIGNhc2UgaXQgd2FzIGNsZWFyLCBJIHN0cm9uZ2x5IGRpc2xpa2UgYWRk
aW5nIGt2bV9nZXRfcnVubmluZ192Y3B1KCkuCj4gSU1PLCBpdCdzIGEgdW5uZWNlc3NhcnkgaGFj
ay4gIFRoZSBwcm9wZXIgY2hhbmdlIHRvIGVuc3VyZSBhIHZhbGlkIHZDUFUgaXMKPiBzZWVuIGJ5
IG1hcmtfcGFnZV9kaXJ0eV9pbl9yaW5nKCkgd2hlbiB0aGVyZSBpcyBhIGN1cnJlbnQgdkNQVSBp
cyB0bwo+IHBsdW1iIHRoZSB2Q1BVIGRvd24gdGhyb3VnaCB0aGUgdmFyaW91cyBjYWxsIHN0YWNr
cy4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
