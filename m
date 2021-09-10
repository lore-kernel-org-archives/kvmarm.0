Return-Path: <SRS0=KxuI=OA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.4 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD43BC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 08:42:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 61654611AD
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 08:42:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 61654611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D23124B188;
	Fri, 10 Sep 2021 04:42:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id olsLKDY7krrl; Fri, 10 Sep 2021 04:42:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7694B17E;
	Fri, 10 Sep 2021 04:42:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35EF84B149
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 04:42:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XfPKBmLAB2AZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Sep 2021 04:42:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED0424B13A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 04:42:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631263350;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=4PAmqK0AZfTXsxp0NXAfSvFh8GVmMkYIerkksseWE4E=;
 b=IVSV6mKquSreRAwrkaF9t1mC+ym5J5C5OG+GvDj7mDqJbdHKFcvxCZUMSDX1nZ3eFCSoRy
 tLD4uVOkOG/6hT/CLJL1I8knZJhZ55vz8DtMrxzAQy1TL3gEtivfPZoizCedJuF8Vsd/28
 xZPLsOmk/QqoqB0OArlAcWU81akWU2c=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-NLvSIxhVO6eKSF6oFDqg2A-1; Fri, 10 Sep 2021 04:42:27 -0400
X-MC-Unique: NLvSIxhVO6eKSF6oFDqg2A-1
Received: by mail-wm1-f69.google.com with SMTP id
 m12-20020a05600c3b0c00b002ff62df2774so631616wms.9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 01:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=4PAmqK0AZfTXsxp0NXAfSvFh8GVmMkYIerkksseWE4E=;
 b=aDHG1HVXnRQTfG3HIwuIgDHT9+KioMryfP9moD9IHXdls9jPzjTInpsuhyx62mz9pP
 hxpbNstyVp+r7jo4I8xEBUTs1GbMXQM3tEgIxufjYAWw96AXiYkj15maSr+knPEQq4YX
 QFvs2Vm4/wlrdYv4tNomKQGpujiCS4p/x0CQtDXvgv+9o07RRtfe6uBPM+qvEn1PfsDa
 aUKrbSXq9uoLnR5sy7v81CKJaHxNYnNPCk/N7PAg/3hkl0x0shd4lCAd6hgsXjANBQ9F
 b6qgNyCs0vfKICqVknk2j9f70Npn9/L0+9TYVFUEeGjlWPN5vu9oeGBpNowT8HWwQcv2
 eYSQ==
X-Gm-Message-State: AOAM531FcwP6kO+J2yyE/p7B9QmTk7+EYYb22lzDBsAxE7jQ/HIYeWmK
 Yd4WpxnU7TFFdt0z+iQEwq8Gbsqyl8EQpDCAnl71JsejrIKoFm0J8fzUPDiYGccHJ2GV7aZ1+aZ
 qVi/ahWTbHgq+itoPZCCo0ZHV
X-Received: by 2002:a5d:4245:: with SMTP id s5mr8618252wrr.237.1631263346081; 
 Fri, 10 Sep 2021 01:42:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIlkFxf2waJe6/Mor40awy3B6n2CJIC22w+EP8RGLtZz+weP4GXQg+kzR3GTUle7QcuZ7FAg==
X-Received: by 2002:a5d:4245:: with SMTP id s5mr8618224wrr.237.1631263345853; 
 Fri, 10 Sep 2021 01:42:25 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id a10sm4124367wrd.51.2021.09.10.01.42.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 10 Sep 2021 01:42:25 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To: Alexandru Elisei <alexandru.elisei@arm.com>,
 Ricardo Koller <ricarkol@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com> <YTo6kX7jGeR3XvPg@google.com>
 <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
Date: Fri, 10 Sep 2021 10:42:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: eric.auger@redhat.com
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

SGkgQWxleGFuZHJ1LAoKT24gOS8xMC8yMSAxMDoyOCBBTSwgQWxleGFuZHJ1IEVsaXNlaSB3cm90
ZToKPiBIaSBSaWNhcmRvLAo+Cj4gT24gOS85LzIxIDU6NDcgUE0sIFJpY2FyZG8gS29sbGVyIHdy
b3RlOgo+PiBPbiBUaHUsIFNlcCAwOSwgMjAyMSBhdCAxMToyMDoxNUFNICswMTAwLCBBbGV4YW5k
cnUgRWxpc2VpIHdyb3RlOgo+Pj4gSGkgUmljYXJkbywKPj4+Cj4+PiBPbiA5LzgvMjEgMTA6MDMg
UE0sIFJpY2FyZG8gS29sbGVyIHdyb3RlOgo+Pj4+IEV4dGVuZCB2Z2ljX3YzX2NoZWNrX2Jhc2Uo
KSB0byB2ZXJpZnkgdGhhdCB0aGUgcmVkaXN0cmlidXRvciByZWdpb25zCj4+Pj4gZG9uJ3QgZ28g
YWJvdmUgdGhlIFZNLXNwZWNpZmllZCBJUEEgc2l6ZSAocGh5c19zaXplKS4gVGhpcyBjYW4gaGFw
cGVuCj4+Pj4gd2hlbiB1c2luZyB0aGUgbGVnYWN5IEtWTV9WR0lDX1YzX0FERFJfVFlQRV9SRURJ
U1QgYXR0cmlidXRlIHdpdGg6Cj4+Pj4KPj4+PiAgIGJhc2UgKyBzaXplID4gcGh5c19zaXplIEFO
RCBiYXNlIDwgcGh5c19zaXplCj4+Pj4KPj4+PiB2Z2ljX3YzX2NoZWNrX2Jhc2UoKSBpcyB1c2Vk
IHRvIGNoZWNrIHRoZSByZWRpc3QgcmVnaW9ucyBiYXNlcyB3aGVuCj4+Pj4gc2V0dGluZyB0aGVt
ICh3aXRoIHRoZSB2Y3B1cyBhZGRlZCBzbyBmYXIpIGFuZCB3aGVuIGF0dGVtcHRpbmcgdGhlIGZp
cnN0Cj4+Pj4gdmNwdS1ydW4uCj4+Pj4KPj4+PiBTaWduZWQtb2ZmLWJ5OiBSaWNhcmRvIEtvbGxl
ciA8cmljYXJrb2xAZ29vZ2xlLmNvbT4KPj4+PiAtLS0KPj4+PiAgYXJjaC9hcm02NC9rdm0vdmdp
Yy92Z2ljLXYzLmMgfCA0ICsrKysKPj4+PiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygr
KQo+Pj4+Cj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jIGIv
YXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKPj4+PiBpbmRleCA2NjAwNGY2MWNkODMuLjVh
ZmQ5ZjZmNjhmNiAxMDA2NDQKPj4+PiAtLS0gYS9hcmNoL2FybTY0L2t2bS92Z2ljL3ZnaWMtdjMu
Ywo+Pj4+ICsrKyBiL2FyY2gvYXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jCj4+Pj4gQEAgLTUxMiw2
ICs1MTIsMTAgQEAgYm9vbCB2Z2ljX3YzX2NoZWNrX2Jhc2Uoc3RydWN0IGt2bSAqa3ZtKQo+Pj4+
ICAJCWlmIChyZHJlZy0+YmFzZSArIHZnaWNfdjNfcmRfcmVnaW9uX3NpemUoa3ZtLCByZHJlZykg
PAo+Pj4+ICAJCQlyZHJlZy0+YmFzZSkKPj4+PiAgCQkJcmV0dXJuIGZhbHNlOwo+Pj4+ICsKPj4+
PiArCQlpZiAocmRyZWctPmJhc2UgKyB2Z2ljX3YzX3JkX3JlZ2lvbl9zaXplKGt2bSwgcmRyZWcp
ID4KPj4+PiArCQkJa3ZtX3BoeXNfc2l6ZShrdm0pKQo+Pj4+ICsJCQlyZXR1cm4gZmFsc2U7Cj4+
PiBMb29rcyB0byBtZSBsaWtlIHRoaXMgc2FtZSBjaGVjayAoYW5kIHRoZSBvdmVyZmxvdyBvbmUg
YmVmb3JlIGl0KSBpcyBkb25lIHdoZW4KPj4+IGFkZGluZyBhIG5ldyBSZWRpc3RyaWJ1dG9yIHJl
Z2lvbiBpbiBrdm1fdmdpY19hZGRyKCkgLT4gdmdpY192M19zZXRfcmVkaXN0X2Jhc2UoKQo+Pj4g
LT4gdmdpY192M19hbGxvY19yZWRpc3RfcmVnaW9uKCkgLT4gdmdpY19jaGVja19pb2FkZHIoKS4g
QXMgZmFyIGFzIEkgY2FuIHRlbGwsCj4+PiBrdm1fdmdpY19hZGRyKCkgaGFuZGxlcyBib3RoIHdh
eXMgb2Ygc2V0dGluZyB0aGUgUmVkaXN0cmlidXRvciBhZGRyZXNzLgo+Pj4KPj4+IFdpdGhvdXQg
dGhpcyBwYXRjaCwgZGlkIHlvdSBtYW5hZ2UgdG8gc2V0IGEgYmFzZSBhZGRyZXNzIHN1Y2ggdGhh
dCBiYXNlICsgc2l6ZSA+Cj4+PiBrdm1fcGh5c19zaXplKCk/Cj4+Pgo+PiBZZXMsIHdpdGggdGhl
IEtWTV9WR0lDX1YzX0FERFJfVFlQRV9SRURJU1QgbGVnYWN5IEFQSS4gVGhlIGVhc2llc3Qgd2F5
Cj4+IHRvIGdldCB0byB0aGlzIHNpdHVhdGlvbiBpcyB3aXRoIHRoZSBzZWxmdGVzdCBpbiBwYXRj
aCAyLiAgSSB0aGVuIHRyaWVkCj4+IGFuIGV4dHJhIGV4cGVyaW1lbnQ6IG1hcCB0aGUgZmlyc3Qg
cmVkaXN0cmlidXRvciwgcnVuIHRoZSBmaXJzdCB2Y3B1LAo+PiBhbmQgYWNjZXNzIHRoZSByZWRp
c3QgZnJvbSBpbnNpZGUgdGhlIGd1ZXN0LiBLVk0gZGlkbid0IGNvbXBsYWluIGluIGFueQo+PiBv
ZiB0aGVzZSBzdGVwcy4KPiBZZXMsIEVyaWMgcG9pbnRlZCBvdXQgdGhhdCBJIHdhcyBtaXN0YWtl
biBhbmQgdGhlcmUgaXMgbm8gY2hlY2sgYmVpbmcgZG9uZSBmb3IKPiBiYXNlICsgc2l6ZSA+IGt2
bV9waHlzX3NpemUoKS4KPgo+IFdoYXQgSSB3YXMgdHJ5aW5nIHRvIHNheSBpcyB0aGF0IHRoaXMg
Y2hlY2sgaXMgYmV0dGVyIGRvbmUgd2hlbiB0aGUgdXNlciBjcmVhdGVzIGEKPiBSZWRpc3RyaWJ1
dG9yIHJlZ2lvbiwgbm90IHdoZW4gYSBWQ1BVIGlzIGZpcnN0IHJ1bi4gV2UgaGF2ZSBldmVyeXRo
aW5nIHdlIG5lZWQgdG8KPiBtYWtlIHRoZSBjaGVjayB3aGVuIGEgcmVnaW9uIGlzIGNyZWF0ZWQs
IHdoeSB3YWl0IHVudGlsIHRoZSBWQ1BVIGlzIHJ1bj8KPgo+IEZvciBleGFtcGxlLCB2Z2ljX3Yz
X2luc2VydF9yZWRpc3RfcmVnaW9uKCkgaXMgY2FsbGVkIGVhY2ggdGltZSB0aGUgYWRkcyBhIG5l
dwo+IFJlZGlzdHJpYnV0b3IgcmVnaW9uICh2aWEgZWl0aGVyIG9mIHRoZSB0d28gQVBJcyksIGFu
ZCBhbHJlYWR5IGhhcyBhIGNoZWNrIGZvciB0aGUKPiB1cHBlciBsaW1pdCBvdmVyZmxvd2luZyAo
aWRlbnRpY2FsIHRvIHRoZSBjaGVjayBpbiB2Z2ljX3YzX2NoZWNrX2Jhc2UoKSkuIEkgd291bGQK
PiBhZGQgdGhlIGNoZWNrIGFnYWluc3QgdGhlIG1heGltdW0gSVBBIHNpemUgdGhlcmUuCnlvdSBz
ZWVtIHRvIHJlZmVyIHRvIGFuIG9sZCBrZXJuZWwgYXMgdmdpY192M19pbnNlcnRfcmVkaXN0X3Jl
Z2lvbiB3YXMKcmVuYW1lZCBpbnRvwqAgdmdpY192M19hbGxvY19yZWRpc3RfcmVnaW9uIGluCmU1
YTM1NjM1NDY0YiBrdm06IGFybTY0OiB2Z2ljLXYzOiBJbnRyb2R1Y2UgdmdpY192M19mcmVlX3Jl
ZGlzdF9yZWdpb24oKQoKSSB0aGluayBpbiBjYXNlIHlvdSB1c2UgdGhlIG9sZCByZGlzdCBBUEkg
eW91IGRvIG5vdCBrbm93IHlldCB0aGUgc2l6ZQpvZiB0aGUgcmVkaXN0IHJlZ2lvbiBhdCB0aGlz
IHBvaW50IChjb3VudD0wKSwgaGVuY2UgUmljYXJkbydzIGNob2ljZSB0bwpkbyB0aGUgY2hlY2sg
bGF0dGVyLgo+Cj4gQWxzbywgYmVjYXVzZSB2Z2ljX3YzX2luc2VydF9yZWRpc3RfcmVnaW9uKCkg
YWxyZWFkeSBjaGVja3MgZm9yIG92ZXJmbG93LCBJCj4gYmVsaWV2ZSB0aGUgb3ZlcmZsb3cgY2hl
Y2sgaW4gdmdpY192M19jaGVja19iYXNlKCkgaXMgcmVkdW5kYW50Lgo+Cj4gQXMgZmFyIGFzIEkg
Y2FuIHRlbGwsIHZnaWNfdjNfY2hlY2tfYmFzZSgpIGlzIHRoZXJlIHRvIG1ha2Ugc3VyZSB0aGF0
IHRoZQo+IERpc3RyaWJ1dG9yIGRvZXNuJ3Qgb3ZlcmxhcCB3aXRoIGFueSBvZiB0aGUgUmVkaXN0
cmlidXRvcnMsIGFuZCBiZWNhdXNlIHRoZQo+IFJlZGlzdHJpYnV0b3JzIGFuZCB0aGUgRGlzdHJp
YnV0b3IgY2FuIGJlIGNyZWF0ZWQgaW4gYW55IG9yZGVyLCB3ZSBkZWZlciB0aGUgY2hlY2sKPiB1
bnRpbCB0aGUgZmlyc3QgVkNQVSBpcyBydW4uIEkgbWlnaHQgYmUgd3JvbmcgYWJvdXQgdGhpcywg
c29tZW9uZSBwbGVhc2UgY29ycmVjdAo+IG1lIGlmIEknbSB3cm9uZy4KPgo+IEFsc28sIGRpZCB5
b3UgdmVyaWZ5IHRoYXQgS1ZNIGlzIGFsc28gZG9pbmcgdGhpcyBjaGVjayBmb3IgR0lDdjI/IEtW
TSBkb2VzCj4gc29tZXRoaW5nIHNpbWlsYXIgYW5kIGNhbGxzIHZnaWNfdjJfY2hlY2tfYmFzZSgp
IHdoZW4gbWFwcGluZyB0aGUgR0lDIHJlc291cmNlcywKPiBhbmQgSSBkb24ndCBzZWUgYSBjaGVj
ayBmb3IgdGhlIG1heGltdW0gSVBBIHNpemUgaW4gdGhhdCBmdW5jdGlvbiBlaXRoZXIuCgpJIHRo
aW5rIHZnaWNfY2hlY2tfaW9hZGRyKCkgY2FsbGVkIGluIGt2bV92Z2ljX2FkZHIoKSBkb2VzIHRo
ZSBqb2IgKGl0CmNoZWNrcyB0aGUgYmFzZSBAKQoKVGhhbmtzCgpFcmljCj4KPiBUaGFua3MsCj4K
PiBBbGV4Cj4KPj4gVGhhbmtzLAo+PiBSaWNhcmRvCj4+Cj4+PiBUaGFua3MsCj4+Pgo+Pj4gQWxl
eAo+Pj4KPj4+PiAgCX0KPj4+PiAgCj4+Pj4gIAlpZiAoSVNfVkdJQ19BRERSX1VOREVGKGQtPnZn
aWNfZGlzdF9iYXNlKSkKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpo
dHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
