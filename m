Return-Path: <SRS0=fBez=57=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA99C38A2B
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 17:06:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 90A4620737
	for <kvmarm@archiver.kernel.org>; Wed, 15 Apr 2020 17:06:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="lVfxioqD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 90A4620737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49DC14B209;
	Wed, 15 Apr 2020 13:06:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GnRrKCUkRTvt; Wed, 15 Apr 2020 13:06:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1C834B22C;
	Wed, 15 Apr 2020 13:06:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C73A4B1D7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 12:20:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dFuZsZ9dEIqi for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Apr 2020 12:20:38 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBAC24B19A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 12:20:38 -0400 (EDT)
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com
 [209.85.166.49])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id A3095206F9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 16:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586967637;
 bh=xiWRRWSIiNJkZgzN/gsKBCqoW4ucuqZrzCPF+0y0s3Y=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=lVfxioqDtBIDtVZe6p4owl9oThM2453JiNHQbwWgv5H2Ku3OmoNzoaCU7Llce8caI
 Iq3sIzpUGf33c90jVVyF6LgwZBQz+Piuxk4ujkuuj3qsmCR7EEe0Pf1TcghTMTbl6j
 2YyERQYlRv0hXfx0ndDZPXN+coDC0EX9BoUi2pGc=
Received: by mail-io1-f49.google.com with SMTP id n10so17723642iom.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Apr 2020 09:20:37 -0700 (PDT)
X-Gm-Message-State: AGi0PuZZW5EUdJmPXSqfcal2XLxm3TG/O7+CYazbdc4DRqBBTZruNE2N
 zjFkTItS4Zy2c9uKPuI/8guQHxC/QRG1Pt8Bvvc=
X-Google-Smtp-Source: APiQypLgOSRPv1bC/QOZQLEX3sYcp6ObUrfMGehj4hFMujnG8x8tCvW9SfKpInZF6hOzPUdOrer1k5rTNzt4nm6uAo8=
X-Received: by 2002:a02:6a1e:: with SMTP id l30mr25608981jac.98.1586967636895; 
 Wed, 15 Apr 2020 09:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200221165532.90618-1-andre.przywara@arm.com>
 <2d3bad43-10a5-3ee1-72e7-e1da1d6c65dd@arm.com>
 <CAMj1kXGUiCLvmJUwrxCc8aHdE30WWfa95ou-tEM8Kv0nj2GdDA@mail.gmail.com>
 <CAMj1kXF6iw47MM_tg5izB9KC-N2zrnQbhwT2TVPOuKdpOBX=ow@mail.gmail.com>
 <d9ae6d29-c2c5-6aa7-15b6-6549fc89c043@arm.com>
In-Reply-To: <d9ae6d29-c2c5-6aa7-15b6-6549fc89c043@arm.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 15 Apr 2020 18:20:25 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHKOBbCKsgYOYuLU+vOALBUbNRysVfVRpKXkh00GvTtEA@mail.gmail.com>
Message-ID: <CAMj1kXHKOBbCKsgYOYuLU+vOALBUbNRysVfVRpKXkh00GvTtEA@mail.gmail.com>
Subject: Re: [PATCH kvmtool v3] Add emulation for CFI compatible flash memory
To: =?UTF-8?Q?Andr=C3=A9_Przywara?= <andre.przywara@arm.com>
X-Mailman-Approved-At: Wed, 15 Apr 2020 13:06:31 -0400
Cc: kvm@vger.kernel.org, Raphael Gault <raphael.gault@arm.com>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>, sami.mujawar@arm.com,
 Will Deacon <will@kernel.org>, kvmarm <kvmarm@lists.cs.columbia.edu>
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

T24gV2VkLCAxNSBBcHIgMjAyMCBhdCAxODoxMSwgQW5kcsOpIFByenl3YXJhIDxhbmRyZS5wcnp5
d2FyYUBhcm0uY29tPiB3cm90ZToKPgo+IE9uIDE1LzA0LzIwMjAgMTY6NTUsIEFyZCBCaWVzaGV1
dmVsIHdyb3RlOgo+ID4gT24gV2VkLCAxNSBBcHIgMjAyMCBhdCAxNzo0MywgQXJkIEJpZXNoZXV2
ZWwgPGFyZGJAa2VybmVsLm9yZz4gd3JvdGU6Cj4gPj4KPiA+PiBPbiBUdWUsIDcgQXByIDIwMjAg
YXQgMTc6MTUsIEFsZXhhbmRydSBFbGlzZWkgPGFsZXhhbmRydS5lbGlzZWlAYXJtLmNvbT4gd3Jv
dGU6Cj4gPj4+Cj4gPj4+IEhpLAo+ID4+Pgo+ID4+PiBJJ3ZlIHRlc3RlZCB0aGlzIHBhdGNoIGJ5
IHJ1bm5pbmcgYmFkYmxvY2tzIGFuZCBmaW8gb24gYSBmbGFzaCBkZXZpY2UgaW5zaWRlIGEKPiA+
Pj4gZ3Vlc3QsIGV2ZXJ5dGhpbmcgd29ya2VkIGFzIGV4cGVjdGVkLgo+ID4+Pgo+ID4+PiBJJ3Zl
IGFsc28gbG9va2VkIGF0IHRoZSBmbG93Y2hhcnRzIGZvciBkZXZpY2Ugb3BlcmF0aW9uIGZyb20g
SW50ZWwgQXBwbGljYXRpb24KPiA+Pj4gTm90ZSA2NDYsIHBhZ2VzIDEyLTIxLCBhbmQgdGhleSBz
ZWVtIGltcGxlbWVudGVkIGNvcnJlY3RseS4KPiA+Pj4KPiA+Pj4gQSBmZXcgbWlub3IgaXNzdWVz
IGJlbG93Lgo+ID4+Pgo+ID4+PiBPbiAyLzIxLzIwIDQ6NTUgUE0sIEFuZHJlIFByenl3YXJhIHdy
b3RlOgo+ID4+Pj4gRnJvbTogUmFwaGFlbCBHYXVsdCA8cmFwaGFlbC5nYXVsdEBhcm0uY29tPgo+
ID4+Pj4KPiA+Pj4+IFRoZSBFREsgSUkgVUVGSSBmaXJtd2FyZSBpbXBsZW1lbnRhdGlvbiByZXF1
aXJlcyBzb21lIHN0b3JhZ2UgZm9yIHRoZSBFRkkKPiA+Pj4+IHZhcmlhYmxlcywgd2hpY2ggaXMg
dHlwaWNhbGx5IHNvbWUgZmxhc2ggc3RvcmFnZS4KPiA+Pj4+IFNpbmNlIHRoaXMgaXMgYWxyZWFk
eSBzdXBwb3J0ZWQgb24gdGhlIEVESyBJSSBzaWRlLCB3ZSBhZGQgYSBDRkkgZmxhc2gKPiA+Pj4+
IGVtdWxhdGlvbiB0byBrdm10b29sLgo+ID4+Pj4gVGhpcyBpcyBiYWNrZWQgYnkgYSBmaWxlLCBz
cGVjaWZpZWQgdmlhIHRoZSAtLWZsYXNoIG9yIC1GIGNvbW1hbmQgbGluZQo+ID4+Pj4gb3B0aW9u
LiBBbnkgZmxhc2ggd3JpdGVzIGRvbmUgYnkgdGhlIGd1ZXN0IHdpbGwgaW1tZWRpYXRlbHkgYmUg
cmVmbGVjdGVkCj4gPj4+PiBpbnRvIHRoaXMgZmlsZSAoa3ZtdG9vbCBtbWFwJ3MgdGhlIGZpbGUp
Lgo+ID4+Pj4gVGhlIGZsYXNoIHdpbGwgYmUgbGltaXRlZCB0byB0aGUgbmVhcmVzdCBwb3dlci1v
Zi0yIHNpemUsIHNvIG9ubHkgdGhlCj4gPj4+PiBmaXJzdCAyIE1CIG9mIGEgMyBNQiBmaWxlIHdp
bGwgYmUgdXNlZC4KPiA+Pj4+Cj4gPj4+PiBUaGlzIGltcGxlbWVudHMgYSBDRkkgZmxhc2ggdXNp
bmcgdGhlICJJbnRlbC9TaGFycCBleHRlbmRlZCBjb21tYW5kCj4gPj4+PiBzZXQiLCBhcyBzcGVj
aWZpZWQgaW46Cj4gPj4+PiAtIEpFREVDIEpFU0Q2OC4wMQo+ID4+Pj4gLSBKRURFQyBKRVAxMzdC
Cj4gPj4+PiAtIEludGVsIEFwcGxpY2F0aW9uIE5vdGUgNjQ2Cj4gPj4+PiBTb21lIGdhcHMgaW4g
dGhvc2Ugc3BlY3MgaGF2ZSBiZWVuIGZpbGxlZCBieSBsb29raW5nIGF0IHJlYWwgZGV2aWNlcyBh
bmQKPiA+Pj4+IG90aGVyIGltcGxlbWVudGF0aW9ucyAoUUVNVSwgTGludXgga2VybmVsIGRyaXZl
cikuCj4gPj4+Pgo+ID4+Pj4gQXQgdGhlIG1vbWVudCB0aGlzIHJlbGllcyBvbiBEVCB0byBhZHZl
cnRpc2UgdGhlIGJhc2UgYWRkcmVzcyBvZiB0aGUKPiA+Pj4+IGZsYXNoIG1lbW9yeSAobWFwcGVk
IGludG8gdGhlIE1NSU8gYWRkcmVzcyBzcGFjZSkgYW5kIGlzIG9ubHkgZW5hYmxlZAo+ID4+Pj4g
Zm9yIEFSTS9BUk02NC4gVGhlIGVtdWxhdGlvbiBpdHNlbGYgaXMgYXJjaGl0ZWN0dXJlIGFnbm9z
dGljLCB0aG91Z2guCj4gPj4+Pgo+ID4+Pj4gVGhpcyBpcyBvbmUgbWlzc2luZyBwaWVjZSB0b3dh
cmQgYSB3b3JraW5nIFVFRkkgYm9vdCB3aXRoIGt2bXRvb2wgb24KPiA+Pj4+IEFSTSBndWVzdHMs
IHRoZSBvdGhlciBpcyB0byBwcm92aWRlIHdyaXRhYmxlIFBDSSBCQVJzLCB3aGljaCBpcyBXSVAu
Cj4gPj4+Pgo+ID4+Cj4gPj4gSSBoYXZlIGdpdmVuIHRoaXMgYSBzcGluIHdpdGggVUVGSSBidWls
dCBmb3Iga3ZtdG9vbCwgYW5kIGl0IGFwcGVhcnMKPiA+PiB0byBiZSB3b3JraW5nIGNvcnJlY3Rs
eS4gSG93ZXZlciwgSSBub3RpY2VkIHRoYXQgaXQgaXMgaW50b2xlcmFibHkKPiA+PiBzbG93LCB3
aGljaCBzZWVtcyB0byBiZSBjYXVzZWQgYnkgdGhlIGZhY3QgdGhhdCBib3RoIGFycmF5IG1vZGUg
YW5kCj4gPj4gY29tbWFuZCBtb2RlIChvciB3aGF0ZXZlciBpdCBpcyBjYWxsZWQgaW4gdGhlIENG
SSBzcGVjKSBhcmUgZnVsbHkKPiA+PiBlbXVsYXRlZCwgd2hlcmVhcyBpbiB0aGUgUUVNVSBpbXBs
ZW1lbnRhdGlvbiAoZm9yIGluc3RhbmNlKSwgdGhlCj4gPj4gcmVnaW9uIGlzIGFjdHVhbGx5IGV4
cG9zZWQgdG8gdGhlIGd1ZXN0IHVzaW5nIGEgcmVhZC1vbmx5IEtWTSBtZW1zbG90Cj4gPj4gaW4g
YXJyYXkgbW9kZSwgYW5kIHNvIHRoZSByZWFkIGFjY2Vzc2VzIGFyZSBtYWRlIG5hdGl2ZWx5Lgo+
ID4+Cj4gPj4gSXQgaXMgYWxzbyBjYXVzaW5nIHByb2JsZW1zIGluIHRoZSBVRUZJIGltcGxlbWVu
dGF0aW9uLCBhcyB3ZSBjYW4gbm8KPiA+PiBsb25nZXIgdXNlIHVuYWxpZ25lZCBhY2Nlc3NlcyB0
byByZWFkIGZyb20gdGhlIHJlZ2lvbiwgd2hpY2ggaXMKPiA+PiBzb21ldGhpbmcgdGhlIGNvZGUg
Y3VycmVudGx5IHJlbGllcyBvbiAoYW5kIHdoaWNoIHdvcmtzIGZpbmUgb24gYWN0dWFsCj4gPj4g
aGFyZHdhcmUgYXMgbG9uZyBhcyB5b3UgdXNlIG5vcm1hbCBub24tY2FjaGVhYmxlIG1hcHBpbmdz
KQo+ID4+Cj4gPgo+ID4gQWN0dWFsbHksIHRoZSBpc3N1ZSBpcyBub3QgYWxpZ25tZW50LiBUaGUg
aXNzdWUgaXMgd2l0aCBpbnN0cnVjdGlvbnMKPiA+IHdpdGggbXVsdGlwbGUgb3V0cHV0cywgd2hp
Y2ggbWVhbnMgeW91IGNhbm5vdCBkbyBhbiBvcmRpbmFyeSBtZW1jcHkoKQo+ID4gZnJvbSB0aGUg
Tk9SIHJlZ2lvbiB1c2luZyBsZHAgaW5zdHJ1Y3Rpb25zLCBhbGlnbmVkIG9yIG5vdC4KPgo+IFll
cywgd2UgdHJhY2VkIHRoYXQgZG93biB0byBhbiAibGRyYiB3aXRoIHBvc3QtaW5jIiwgaW4gdGhl
IG1lbWNweSBjb2RlLgo+IE15IHN1Z2dlc3Rpb24gd2FzIHRvIHByb3ZpZGUgYSB2ZXJzaW9uIG9m
IG1lbWNweV97ZnJvbSx0b31faW8oKSwgYXMKPiBMaW51eCBkb2VzLCB3aGljaCBvbmx5IHVzZXMg
TU1JTyBhY2Nlc3NvcnMgdG8gYXZvaWQgImZhbmN5IiBpbnN0cnVjdGlvbnMuCj4KClRoYXQgaXMg
cG9zc2libGUsIGFuZCB0aGUgaW1wYWN0IG9uIHRoZSBjb2RlIGlzIG1hbmFnZWFibGUsIGdpdmVu
IHRoZQptb2R1bGFyIG5hdHVyZSBvZiBFREsyLgoKPiBCYWNrIGF0IHRoaXMgcG9pbnQgSSB3YXMg
Y2hhbGxlbmdpbmcgdGhlIGlkZWEgb2YgYWNjZXNzaW5nIGEgZmxhc2gKPiBkZXZpY2Ugd2l0aCBh
IG5vcm1hbCBtZW1vcnkgbWFwcGluZywgYmVjYXVzZSBvZiBpdCBmYWlsaW5nIHdoZW4gYmVpbmcg
aW4KPiBzb21lIHF1ZXJ5IG1vZGUuIERvIHlvdSBrbm93IG9mIGFueSBiZXN0IHByYWN0aWNlcyBm
b3IgZmxhc2ggbWFwcGluZ3M/Cj4gQXJlIHR3byBtYXBwaW5ncyBjb21tb24/Cj4KCkluIHRoZSBR
RU1VIHBvcnQgb2YgRURLMiwgd2UgdXNlIG5vcm1hbCBub24tY2FjaGVhYmxlIGZvciB0aGUgZmly
c3QKZmxhc2ggZGV2aWNlLCB3aGljaCBjb250YWlucyB0aGUgZXhlY3V0YWJsZSBpbWFnZSwgYW5k
IGlzIG5vdAp1cGRhdGFibGUgYnkgdGhlIGd1ZXN0LiBUaGUgc2Vjb25kIGZsYXNoIGJhbmsgaXMg
dXNlZCBmb3IgdGhlIHZhcmlhYmxlCnN0b3JlLCBhbmQgaXMgYWN0dWFsbHkgbWFwcGVkIGFzIGEg
ZGV2aWNlIGFsbCB0aGUgdGltZS4KCkFub3RoZXIgdGhpbmcgSSBqdXN0IHJlYWxpemVkIGlzIHRo
YXQgeW91IGNhbm5vdCBmZXRjaCBpbnN0cnVjdGlvbnMKZnJvbSBhbiBlbXVsYXRlZCBmbGFzaCBk
ZXZpY2UgZWl0aGVyLCBzbyB0byBleGVjdXRlIGZyb20gTk9SIGZsYXNoLAp5b3Ugd2lsbCBuZWVk
IGEgdHJ1ZSBtZW1vcnkgbWFwcGluZyBhcyB3ZWxsLgoKU28gaW4gc3VtbWFyeSwgSSB0aGluayB0
aGUgbW9kZSBzd2l0Y2ggaXMgbmVlZGVkIHRvIGJlIGdlbmVyYWxseQp1c2VmdWwsIGV2ZW4gaWYg
dGhlIGN1cnJlbnQgYXBwcm9hY2ggaXMgc3VmZmljaWVudCBmb3IgKHNsb3cpCnJlYWQvd3JpdGUg
dXNpbmcgc3BlY2lhbCBtZW1vcnkgYWNjZXNzb3JzLgpfX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5j
cy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0
aW5mby9rdm1hcm0K
