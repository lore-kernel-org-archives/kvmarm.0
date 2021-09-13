Return-Path: <SRS0=oqs1=OD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B6EC433F5
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 08:51:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A9AD660FBF
	for <kvmarm@archiver.kernel.org>; Mon, 13 Sep 2021 08:51:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A9AD660FBF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203E24B134;
	Mon, 13 Sep 2021 04:51:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 99WaVujkgkK5; Mon, 13 Sep 2021 04:51:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1AC64B135;
	Mon, 13 Sep 2021 04:51:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F93A4B11F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 04:51:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id F+KuraCq+xSa for <kvmarm@lists.cs.columbia.edu>;
 Mon, 13 Sep 2021 04:51:21 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DF2F4B0B9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 04:51:21 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1631523080;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=yQ6qcVkwWXcAQwHWsCF6TpizTZVzjcq4Fc7qFv2w/0c=;
 b=Hk2Teqrlfe//jPIYGTasWWintMp2sVffsdZ+q1LSQF6j2B1QQJ7RctvDg3iA/rImVURofC
 rIKedAIKrK7fGAql71KYr15JVfwTHA2UKyVjoRFjlGd7Uj49RxAOThv53JY9jGsrxywjT4
 cSi+sR6g9cfst3tFcHSR7N9oxDWK2Pc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-OvdVnoAdMT2yJO9ADrToOw-1; Mon, 13 Sep 2021 04:51:19 -0400
X-MC-Unique: OvdVnoAdMT2yJO9ADrToOw-1
Received: by mail-wm1-f70.google.com with SMTP id
 m16-20020a7bca50000000b002ee5287d4bfso1495197wml.7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 13 Sep 2021 01:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=yQ6qcVkwWXcAQwHWsCF6TpizTZVzjcq4Fc7qFv2w/0c=;
 b=QTeElch5JaeOQDrE3PyWS8CD3u9PXruWvsJ1QJ3DD9DFXDGT3IdnperTw9TvctICF6
 p3m7D/p8ABDLLCvti/H5iXINToD7BrzXtPHsk2wW7rZ2mr/XnSkebMGwWf9BTp0Mv0Ev
 jHYulq6ziysQHI4BXGmSUTDeTHX8Dc6t6ck32Z2Y65IyMdRBxJ+egcuCbjOMJ2J8LEd2
 3AUgaG9Tr0g6HBKH/rv4hS+vypy7KfS7HVq/9CHMGa/5F/1nA7xjaJ4OvawLaxprmRXI
 l4ssD+f13QYbKK815T5WRcGmvjxeFrZHhqboQCPX+yoPogz6PNEYj03LSoHiRoZhLhcZ
 ONDA==
X-Gm-Message-State: AOAM532eH8jzw4GOwecZCfX3zpOp/f0K/ScqXVfv1P0SRUirK8eg2t+3
 3JYW26qvVmtAFiOozqraWXyK49MeWKMDfkt8p8B7XvuNBfb3TM1Zg7FWcozupwEtHKWZWbqE8/u
 u9BRCho9vVjAB54s2bbxv70fF
X-Received: by 2002:a05:600c:3641:: with SMTP id
 y1mr9799886wmq.43.1631523078462; 
 Mon, 13 Sep 2021 01:51:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL8rcy7Bc5EXWvq4UYnrHr2+E+WLzjm5heQr57n1Cg85esV3EtrwYMhhnX3kqL0QnTk+pyKg==
X-Received: by 2002:a05:600c:3641:: with SMTP id
 y1mr9799859wmq.43.1631523078195; 
 Mon, 13 Sep 2021 01:51:18 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id z13sm7752107wrs.90.2021.09.13.01.51.16
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Mon, 13 Sep 2021 01:51:17 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To: Ricardo Koller <ricarkol@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com> <YTo6kX7jGeR3XvPg@google.com>
 <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
 <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
 <YTuytfGTDlaoz0yH@google.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <3c521ac9-f18e-e8de-432d-0c0b4a57b737@redhat.com>
Date: Mon, 13 Sep 2021 10:51:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YTuytfGTDlaoz0yH@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, shuah@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu
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

SGkgUmljYXJkbywKCk9uIDkvMTAvMjEgOTozMiBQTSwgUmljYXJkbyBLb2xsZXIgd3JvdGU6Cj4g
SGkgQWxleGFuZHJ1IGFuZCBFcmljLAo+Cj4gT24gRnJpLCBTZXAgMTAsIDIwMjEgYXQgMTA6NDI6
MjNBTSArMDIwMCwgRXJpYyBBdWdlciB3cm90ZToKPj4gSGkgQWxleGFuZHJ1LAo+Pgo+PiBPbiA5
LzEwLzIxIDEwOjI4IEFNLCBBbGV4YW5kcnUgRWxpc2VpIHdyb3RlOgo+Pj4gSGkgUmljYXJkbywK
Pj4+Cj4+PiBPbiA5LzkvMjEgNTo0NyBQTSwgUmljYXJkbyBLb2xsZXIgd3JvdGU6Cj4+Pj4gT24g
VGh1LCBTZXAgMDksIDIwMjEgYXQgMTE6MjA6MTVBTSArMDEwMCwgQWxleGFuZHJ1IEVsaXNlaSB3
cm90ZToKPj4+Pj4gSGkgUmljYXJkbywKPj4+Pj4KPj4+Pj4gT24gOS84LzIxIDEwOjAzIFBNLCBS
aWNhcmRvIEtvbGxlciB3cm90ZToKPj4+Pj4+IEV4dGVuZCB2Z2ljX3YzX2NoZWNrX2Jhc2UoKSB0
byB2ZXJpZnkgdGhhdCB0aGUgcmVkaXN0cmlidXRvciByZWdpb25zCj4+Pj4+PiBkb24ndCBnbyBh
Ym92ZSB0aGUgVk0tc3BlY2lmaWVkIElQQSBzaXplIChwaHlzX3NpemUpLiBUaGlzIGNhbiBoYXBw
ZW4KPj4+Pj4+IHdoZW4gdXNpbmcgdGhlIGxlZ2FjeSBLVk1fVkdJQ19WM19BRERSX1RZUEVfUkVE
SVNUIGF0dHJpYnV0ZSB3aXRoOgo+Pj4+Pj4KPj4+Pj4+ICAgYmFzZSArIHNpemUgPiBwaHlzX3Np
emUgQU5EIGJhc2UgPCBwaHlzX3NpemUKPj4+Pj4+Cj4+Pj4+PiB2Z2ljX3YzX2NoZWNrX2Jhc2Uo
KSBpcyB1c2VkIHRvIGNoZWNrIHRoZSByZWRpc3QgcmVnaW9ucyBiYXNlcyB3aGVuCj4+Pj4+PiBz
ZXR0aW5nIHRoZW0gKHdpdGggdGhlIHZjcHVzIGFkZGVkIHNvIGZhcikgYW5kIHdoZW4gYXR0ZW1w
dGluZyB0aGUgZmlyc3QKPj4+Pj4+IHZjcHUtcnVuLgo+Pj4+Pj4KPj4+Pj4+IFNpZ25lZC1vZmYt
Ynk6IFJpY2FyZG8gS29sbGVyIDxyaWNhcmtvbEBnb29nbGUuY29tPgo+Pj4+Pj4gLS0tCj4+Pj4+
PiAgYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMgfCA0ICsrKysKPj4+Pj4+ICAxIGZpbGUg
Y2hhbmdlZCwgNCBpbnNlcnRpb25zKCspCj4+Pj4+Pgo+Pj4+Pj4gZGlmZiAtLWdpdCBhL2FyY2gv
YXJtNjQva3ZtL3ZnaWMvdmdpYy12My5jIGIvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMK
Pj4+Pj4+IGluZGV4IDY2MDA0ZjYxY2Q4My4uNWFmZDlmNmY2OGY2IDEwMDY0NAo+Pj4+Pj4gLS0t
IGEvYXJjaC9hcm02NC9rdm0vdmdpYy92Z2ljLXYzLmMKPj4+Pj4+ICsrKyBiL2FyY2gvYXJtNjQv
a3ZtL3ZnaWMvdmdpYy12My5jCj4+Pj4+PiBAQCAtNTEyLDYgKzUxMiwxMCBAQCBib29sIHZnaWNf
djNfY2hlY2tfYmFzZShzdHJ1Y3Qga3ZtICprdm0pCj4+Pj4+PiAgCQlpZiAocmRyZWctPmJhc2Ug
KyB2Z2ljX3YzX3JkX3JlZ2lvbl9zaXplKGt2bSwgcmRyZWcpIDwKPj4+Pj4+ICAJCQlyZHJlZy0+
YmFzZSkKPj4+Pj4+ICAJCQlyZXR1cm4gZmFsc2U7Cj4+Pj4+PiArCj4+Pj4+PiArCQlpZiAocmRy
ZWctPmJhc2UgKyB2Z2ljX3YzX3JkX3JlZ2lvbl9zaXplKGt2bSwgcmRyZWcpID4KPj4+Pj4+ICsJ
CQlrdm1fcGh5c19zaXplKGt2bSkpCj4+Pj4+PiArCQkJcmV0dXJuIGZhbHNlOwo+Pj4+PiBMb29r
cyB0byBtZSBsaWtlIHRoaXMgc2FtZSBjaGVjayAoYW5kIHRoZSBvdmVyZmxvdyBvbmUgYmVmb3Jl
IGl0KSBpcyBkb25lIHdoZW4KPj4+Pj4gYWRkaW5nIGEgbmV3IFJlZGlzdHJpYnV0b3IgcmVnaW9u
IGluIGt2bV92Z2ljX2FkZHIoKSAtPiB2Z2ljX3YzX3NldF9yZWRpc3RfYmFzZSgpCj4+Pj4+IC0+
IHZnaWNfdjNfYWxsb2NfcmVkaXN0X3JlZ2lvbigpIC0+IHZnaWNfY2hlY2tfaW9hZGRyKCkuIEFz
IGZhciBhcyBJIGNhbiB0ZWxsLAo+Pj4+PiBrdm1fdmdpY19hZGRyKCkgaGFuZGxlcyBib3RoIHdh
eXMgb2Ygc2V0dGluZyB0aGUgUmVkaXN0cmlidXRvciBhZGRyZXNzLgo+Pj4+Pgo+Pj4+PiBXaXRo
b3V0IHRoaXMgcGF0Y2gsIGRpZCB5b3UgbWFuYWdlIHRvIHNldCBhIGJhc2UgYWRkcmVzcyBzdWNo
IHRoYXQgYmFzZSArIHNpemUgPgo+Pj4+PiBrdm1fcGh5c19zaXplKCk/Cj4+Pj4+Cj4+Pj4gWWVz
LCB3aXRoIHRoZSBLVk1fVkdJQ19WM19BRERSX1RZUEVfUkVESVNUIGxlZ2FjeSBBUEkuIFRoZSBl
YXNpZXN0IHdheQo+Pj4+IHRvIGdldCB0byB0aGlzIHNpdHVhdGlvbiBpcyB3aXRoIHRoZSBzZWxm
dGVzdCBpbiBwYXRjaCAyLiAgSSB0aGVuIHRyaWVkCj4+Pj4gYW4gZXh0cmEgZXhwZXJpbWVudDog
bWFwIHRoZSBmaXJzdCByZWRpc3RyaWJ1dG9yLCBydW4gdGhlIGZpcnN0IHZjcHUsCj4+Pj4gYW5k
IGFjY2VzcyB0aGUgcmVkaXN0IGZyb20gaW5zaWRlIHRoZSBndWVzdC4gS1ZNIGRpZG4ndCBjb21w
bGFpbiBpbiBhbnkKPj4+PiBvZiB0aGVzZSBzdGVwcy4KPj4+IFllcywgRXJpYyBwb2ludGVkIG91
dCB0aGF0IEkgd2FzIG1pc3Rha2VuIGFuZCB0aGVyZSBpcyBubyBjaGVjayBiZWluZyBkb25lIGZv
cgo+Pj4gYmFzZSArIHNpemUgPiBrdm1fcGh5c19zaXplKCkuCj4+Pgo+Pj4gV2hhdCBJIHdhcyB0
cnlpbmcgdG8gc2F5IGlzIHRoYXQgdGhpcyBjaGVjayBpcyBiZXR0ZXIgZG9uZSB3aGVuIHRoZSB1
c2VyIGNyZWF0ZXMgYQo+Pj4gUmVkaXN0cmlidXRvciByZWdpb24sIG5vdCB3aGVuIGEgVkNQVSBp
cyBmaXJzdCBydW4uIFdlIGhhdmUgZXZlcnl0aGluZyB3ZSBuZWVkIHRvCj4+PiBtYWtlIHRoZSBj
aGVjayB3aGVuIGEgcmVnaW9uIGlzIGNyZWF0ZWQsIHdoeSB3YWl0IHVudGlsIHRoZSBWQ1BVIGlz
IHJ1bj8KPj4+Cj4+PiBGb3IgZXhhbXBsZSwgdmdpY192M19pbnNlcnRfcmVkaXN0X3JlZ2lvbigp
IGlzIGNhbGxlZCBlYWNoIHRpbWUgdGhlIGFkZHMgYSBuZXcKPj4+IFJlZGlzdHJpYnV0b3IgcmVn
aW9uICh2aWEgZWl0aGVyIG9mIHRoZSB0d28gQVBJcyksIGFuZCBhbHJlYWR5IGhhcyBhIGNoZWNr
IGZvciB0aGUKPj4+IHVwcGVyIGxpbWl0IG92ZXJmbG93aW5nIChpZGVudGljYWwgdG8gdGhlIGNo
ZWNrIGluIHZnaWNfdjNfY2hlY2tfYmFzZSgpKS4gSSB3b3VsZAo+Pj4gYWRkIHRoZSBjaGVjayBh
Z2FpbnN0IHRoZSBtYXhpbXVtIElQQSBzaXplIHRoZXJlLgo+PiB5b3Ugc2VlbSB0byByZWZlciB0
byBhbiBvbGQga2VybmVsIGFzIHZnaWNfdjNfaW5zZXJ0X3JlZGlzdF9yZWdpb24gd2FzCj4+IHJl
bmFtZWQgaW50b8KgIHZnaWNfdjNfYWxsb2NfcmVkaXN0X3JlZ2lvbiBpbgo+PiBlNWEzNTYzNTQ2
NGIga3ZtOiBhcm02NDogdmdpYy12MzogSW50cm9kdWNlIHZnaWNfdjNfZnJlZV9yZWRpc3RfcmVn
aW9uKCkKPj4KPj4gSSB0aGluayBpbiBjYXNlIHlvdSB1c2UgdGhlIG9sZCByZGlzdCBBUEkgeW91
IGRvIG5vdCBrbm93IHlldCB0aGUgc2l6ZQo+PiBvZiB0aGUgcmVkaXN0IHJlZ2lvbiBhdCB0aGlz
IHBvaW50IChjb3VudD0wKSwgaGVuY2UgUmljYXJkbydzIGNob2ljZSB0bwo+PiBkbyB0aGUgY2hl
Y2sgbGF0dGVyLgo+IEp1c3Qgd2FudGVkIHRvIGFkZCBvbmUgbW9yZSBkZXRhaWwuIHZnaWNfdjNf
Y2hlY2tfYmFzZSgpIGlzIGFsc28gY2FsbGVkCj4gd2hlbiBjcmVhdGluZyB0aGUgcmVkaXN0cmli
dXRvciByZWdpb24gKHZpYSB2Z2ljX3YzX3NldF9yZWRpc3RfYmFzZSAtPgo+IHZnaWNfcmVnaXN0
ZXJfcmVkaXN0X2lvZGV2KS4gVGhpcyBwYXRjaCByZXVzZXMgdGhhdCBjaGVjayBmb3IgdGhlIG9s
ZAo+IHJlZGlzdCBBUEkgdG8gYWxzbyBjaGVjayBmb3IgImJhc2UgKyBzaXplID4ga3ZtX3BoeXNf
c2l6ZSgpIiB3aXRoIGEgc2l6ZQo+IGNhbGN1bGF0ZWQgdXNpbmcgdGhlIHZjcHVzIGFkZGVkIHNv
IGZhci4KPgo+Pj4gQWxzbywgYmVjYXVzZSB2Z2ljX3YzX2luc2VydF9yZWRpc3RfcmVnaW9uKCkg
YWxyZWFkeSBjaGVja3MgZm9yIG92ZXJmbG93LCBJCj4+PiBiZWxpZXZlIHRoZSBvdmVyZmxvdyBj
aGVjayBpbiB2Z2ljX3YzX2NoZWNrX2Jhc2UoKSBpcyByZWR1bmRhbnQuCj4+Pgo+IEl0J3MgcmVk
dW5kYW50IGZvciB0aGUgbmV3IHJlZGlzdCBBUEksIGJ1dCBzdGlsbCBuZWVkZWQgZm9yIHRoZSBv
bGQKPiByZWRpc3QgQVBJLgo+Cj4+PiBBcyBmYXIgYXMgSSBjYW4gdGVsbCwgdmdpY192M19jaGVj
a19iYXNlKCkgaXMgdGhlcmUgdG8gbWFrZSBzdXJlIHRoYXQgdGhlCj4+PiBEaXN0cmlidXRvciBk
b2Vzbid0IG92ZXJsYXAgd2l0aCBhbnkgb2YgdGhlIFJlZGlzdHJpYnV0b3JzLCBhbmQgYmVjYXVz
ZSB0aGUKPj4+IFJlZGlzdHJpYnV0b3JzIGFuZCB0aGUgRGlzdHJpYnV0b3IgY2FuIGJlIGNyZWF0
ZWQgaW4gYW55IG9yZGVyLCB3ZSBkZWZlciB0aGUgY2hlY2sKPj4+IHVudGlsIHRoZSBmaXJzdCBW
Q1BVIGlzIHJ1bi4gSSBtaWdodCBiZSB3cm9uZyBhYm91dCB0aGlzLCBzb21lb25lIHBsZWFzZSBj
b3JyZWN0Cj4+PiBtZSBpZiBJJ20gd3JvbmcuCj4+Pgo+Pj4gQWxzbywgZGlkIHlvdSB2ZXJpZnkg
dGhhdCBLVk0gaXMgYWxzbyBkb2luZyB0aGlzIGNoZWNrIGZvciBHSUN2Mj8gS1ZNIGRvZXMKPj4+
IHNvbWV0aGluZyBzaW1pbGFyIGFuZCBjYWxscyB2Z2ljX3YyX2NoZWNrX2Jhc2UoKSB3aGVuIG1h
cHBpbmcgdGhlIEdJQyByZXNvdXJjZXMsCj4+PiBhbmQgSSBkb24ndCBzZWUgYSBjaGVjayBmb3Ig
dGhlIG1heGltdW0gSVBBIHNpemUgaW4gdGhhdCBmdW5jdGlvbiBlaXRoZXIuCj4+IEkgdGhpbmsg
dmdpY19jaGVja19pb2FkZHIoKSBjYWxsZWQgaW4ga3ZtX3ZnaWNfYWRkcigpIGRvZXMgdGhlIGpv
YiAoaXQKPj4gY2hlY2tzIHRoZSBiYXNlIEApCj4+Cj4gSXQgc2VlbXMgdGhhdCBHSUN2MiBzdWZm
ZXJzIGZyb20gdGhlIHNhbWUgcHJvYmxlbS4gVGhlIGNwdSBpbnRlcmZhY2UKPiBiYXNlIGlzIGNo
ZWNrZWQgYnV0IHRoZSBlbmQgY2FuIGV4dGVuZCBhYm92ZSBJUEEgc2l6ZS4gTm90ZSB0aGF0IHRo
ZSBjcHUKPiBpbnRlcmZhY2UgaXMgOEtCcyBhbmQgdmdpY19jaGVja19pb2FkZHIoKSBpcyBvbmx5
IGNoZWNraW5nIHRoYXQgaXRzIGJhc2UKSSBtaXNzZWQgdGhpcyA4a0IgdGhpbmd5Lgo+IGlzIDRL
QiBhbGlnbmVkIGFuZCBiZWxvdyBJUEEgc2l6ZS4gVGhlIGRpc3RyaWJ1dG9yIHJlZ2lvbiBpcyA0
S0Igc28KPiB2Z2ljX2NoZWNrX2lvYWRkcigpIGlzIGVub3VnaCBpbiB0aGF0IGNhc2UuCj4KPiBX
aGF0IGFib3V0IHRoZSBmb2xsb3dpbmc/Cj4KPiBJIGNhbiB3b3JrIG9uIHRoZSBuZXh0IHZlcnNp
b24gb2YgdGhpcyBwYXRjaCAodjIgaGFzIHRoZSBHSUN2MiBpc3N1ZSkKPiB3aGljaCBhZGRzIHZn
aWNfY2hlY2tfcmFuZ2UoKSwgd2hpY2ggaXMgbGlrZSB2Z2ljX2NoZWNrX2lvYWRkcigpIGJ1dAo+
IHdpdGggYSBzaXplIGFyZy4gIGt2bV92Z2ljX2FkZHIoKSBjYW4gdGhlbiBjYWxsIHZnaWNfY2hl
Y2tfcmFuZ2UoKSBhbmQKPiBkbyBhbGwgdGhlIGNoZWNrcyBmb3IgR0lDdjIgYW5kIEdJQ3YzLiBO
b3RlIHRoYXQgZm9yIEdJQ3YyLCB0aGVyZSdzIG5vCj4gbmVlZCB0byB3YWl0IHVudGlsIGZpcnN0
IHZjcHUgcnVuIHRvIGRvIHRoZSBjaGVjay4gQWxzbyBub3RlIHRoYXQgSSB3aWxsCj4gaGF2ZSB0
byBrZWVwIHRoZSBjaGFuZ2UgaW4gdmdpY192M19jaGVja19iYXNlKCkgdG8gY2hlY2sgZm9yIHRo
ZSBvbGQgdjMKPiByZWRpc3QgQVBJIGF0IGZpcnN0IHZjcHUgcnVuLgpMb29raW5nIGZvcndhcmQg
dG8gcmV2aWV3aW5nIGl0LgoKVGhhbmtzCgpFcmljCj4KPiBUaGFua3MsCj4gUmljYXJkbwo+Cj4+
IFRoYW5rcwo+Pgo+PiBFcmljCj4+PiBUaGFua3MsCj4+Pgo+Pj4gQWxleAo+Pj4KPj4+PiBUaGFu
a3MsCj4+Pj4gUmljYXJkbwo+Pj4+Cj4+Pj4+IFRoYW5rcywKPj4+Pj4KPj4+Pj4gQWxleAo+Pj4+
Pgo+Pj4+Pj4gIAl9Cj4+Pj4+PiAgCj4+Pj4+PiAgCWlmIChJU19WR0lDX0FERFJfVU5ERUYoZC0+
dmdpY19kaXN0X2Jhc2UpKQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1
Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
