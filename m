Return-Path: <SRS0=z9tc=KD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75031C433B4
	for <kvmarm@archiver.kernel.org>; Sat,  8 May 2021 09:18:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D80CB61448
	for <kvmarm@archiver.kernel.org>; Sat,  8 May 2021 09:18:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D80CB61448
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D1F14B7F9;
	Sat,  8 May 2021 05:18:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GQkgYrLjnf7j; Sat,  8 May 2021 05:18:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DBED64B7FA;
	Sat,  8 May 2021 05:18:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09DE34B599
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 21:52:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zk+yyO2s3x2w for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 21:52:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEFB64B590
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 21:52:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620438722;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=qaU4UN52bL9DeZ0ND4jhfpiSI9Et+mZ9RMw7As/kczA=;
 b=Ag+k+IIpeLZ9JnB8sTxk6S7tAo0WEJvITF/HE7DpX2mw01zcbtzNe+QJFxr2kUK9ZdxP7l
 VAFu7mSyj2JbWWbnmh6TdJf50NicqG5PmJ971psq6oDDqgbGE8AvWUB34iJpmQXAlonZYu
 h/aBzIS2hb8Kq1KFB0HGGBi1c8qsxLE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-560-EHqKB97XOb2zg-q63RXjLQ-1; Fri, 07 May 2021 21:51:58 -0400
X-MC-Unique: EHqKB97XOb2zg-q63RXjLQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com
 [10.5.11.15])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20C30107ACC7;
 Sat,  8 May 2021 01:51:57 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-251.pek2.redhat.com
 [10.72.12.251])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 913785D740;
 Sat,  8 May 2021 01:51:41 +0000 (UTC)
Subject: Re: Question on guest enable msi fail when using GICv4/4.1
To: Marc Zyngier <maz@kernel.org>, Zhu Lingshan <lingshan.zhu@intel.com>,
 Shaokun Zhang <zhangshaokun@hisilicon.com>
References: <3a2c66d6-6ca0-8478-d24b-61e8e3241b20@hisilicon.com>
 <87k0oaq5jf.wl-maz@kernel.org>
 <cf870bcf-1173-a70b-2b55-4209abcbcbc3@hisilicon.com>
 <878s4qq00u.wl-maz@kernel.org> <874kfepht4.wl-maz@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Message-ID: <373c70d3-eda3-8e84-d138-2f90d4e55217@redhat.com>
Date: Sat, 8 May 2021 09:51:39 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <874kfepht4.wl-maz@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mailman-Approved-At: Sat, 08 May 2021 05:18:12 -0400
Cc: kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
 linux-pci@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>,
 Alex Williamson <alex.williamson@redhat.com>,
 Bjorn Helgaas <bhelgaas@google.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="gbk"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

CtTaIDIwMjEvNS84IMnPzucxOjM2LCBNYXJjIFp5bmdpZXIg0LS1wDoKPiBPbiBGcmksIDA3IE1h
eSAyMDIxIDEyOjAyOjU3ICswMTAwLAo+IE1hcmMgWnluZ2llciA8bWF6QGtlcm5lbC5vcmc+IHdy
b3RlOgo+PiBPbiBGcmksIDA3IE1heSAyMDIxIDEwOjU4OjIzICswMTAwLAo+PiBTaGFva3VuIFpo
YW5nIDx6aGFuZ3NoYW9rdW5AaGlzaWxpY29uLmNvbT4gd3JvdGU6Cj4+PiBIaSBNYXJjLAo+Pj4K
Pj4+IFRoYW5rcyBmb3IgeW91ciBxdWljayByZXBseS4KPj4+Cj4+PiBPbiAyMDIxLzUvNyAxNzow
MywgTWFyYyBaeW5naWVyIHdyb3RlOgo+Pj4+IE9uIEZyaSwgMDcgTWF5IDIwMjEgMDY6NTc6MDQg
KzAxMDAsCj4+Pj4gU2hhb2t1biBaaGFuZyA8emhhbmdzaGFva3VuQGhpc2lsaWNvbi5jb20+IHdy
b3RlOgo+Pj4+PiBbVGhpcyBsZXR0ZXIgY29tZXMgZnJvbSBOaWFueWFvIFRhbmddCj4+Pj4+Cj4+
Pj4+IEhpLAo+Pj4+Pgo+Pj4+PiBVc2luZyBHSUN2NC80LjEgYW5kIG1zaSBjYXBhYmlsaXR5LCBn
dWVzdCB2ZiBkcml2ZXIgcmVxdWlyZXMgMwo+Pj4+PiB2ZWN0b3JzIGFuZCBlbmFibGUgbXNpLCB3
aWxsIGxlYWQgdG8gZ3Vlc3Qgc3R1Y2suCj4+Pj4gU3R1Y2sgaG93Pwo+Pj4gR3Vlc3Qgc2VyaWFs
IGRvZXMgbm90IHJlc3BvbnNlIGFueW1vcmUgYW5kIGd1ZXN0IG5ldHdvcmsgc2h1dGRvd24uCj4+
Pgo+Pj4+PiBRZW11IGdldHMgbnVtYmVyIG9mIGludGVycnVwdHMgZnJvbSBNdWx0aXBsZSBNZXNz
YWdlIENhcGFibGUgZmllbGQKPj4+Pj4gc2V0IGJ5IGd1ZXN0LiBUaGlzIGZpZWxkIGlzIGFsaWdu
ZWQgdG8gYSBwb3dlciBvZiAyKGlmIGEgZnVuY3Rpb24KPj4+Pj4gcmVxdWlyZXMgMyB2ZWN0b3Jz
LCBpdCBpbml0aWFsaXplcyBpdCB0byAyKS4KPj4+PiBTbyBJIGd1ZXNzIHRoaXMgaXMgYSBNdWx0
aU1TSSBkZXZpY2Ugd2l0aCA0IHZlY3RvcnMsIHJpZ2h0Pwo+Pj4+Cj4+PiBZZXMsIGl0IGNhbiBz
dXBwb3J0IG1heGltdW0gb2YgMzIgbXNpIGludGVycnVwdHMsIGFuZCB2ZiBkcml2ZXIgb25seSB1
c2UgMyBtc2kuCj4+Pgo+Pj4+PiBIb3dldmVyLCBndWVzdCBkcml2ZXIganVzdCBzZW5kcyAzIG1h
cGktY21kIHRvIHZpdHMgYW5kIDMgaXRlCj4+Pj4+IGVudHJpZXMgaXMgcmVjb3JkZWQgaW4gaG9z
dC4gIFZmaW8gaW5pdGlhbGl6ZXMgbXNpIGludGVycnVwdHMgdXNpbmcKPj4+Pj4gdGhlIG51bWJl
ciBvZiBpbnRlcnJ1cHRzIDQgcHJvdmlkZSBieSBxZW11LiAgV2hlbiBpdCBjb21lcyB0byB0aGUK
Pj4+Pj4gNHRoIG1zaSB3aXRob3V0IGl0ZSBpbiB2aXRzLCBpbiBpcnFfYnlwYXNzX3JlZ2lzdGVy
X3Byb2R1Y2VyLAo+Pj4+PiBwcm9kdWNlciBhbmQgY29uc3VtZXIgd2lsbCBfX2Nvbm5lY3QgZmFp
bCwgZHVlIHRvIGZpbmRfaXRlIGZhaWwsIGFuZAo+Pj4+PiBkbyBub3QgcmVzdW1lIGd1ZXN0Lgo+
Pj4+IExldCBtZSByZXBocmFzZSB0aGlzIHRvIGNoZWNrIHRoYXQgSSB1bmRlcnN0YW5kIGl0Ogo+
Pj4+IC0gVGhlIGRldmljZSBoYXMgNCB2ZWN0b3JzCj4+Pj4gLSBUaGUgZ3Vlc3Qgb25seSBjcmVh
dGUgbWFwcGluZ3MgZm9yIDMgb2YgdGhlbQo+Pj4+IC0gVkZJTyBjYWxscyBrdm1fdmdpY192NF9z
ZXRfZm9yd2FyZGluZygpIGZvciBlYWNoIHZlY3Rvcgo+Pj4+IC0gS1ZNIGRvZXNuJ3QgaGF2ZSBh
IG1hcHBpbmcgZm9yIHRoZSA0dGggdmVjdG9yIGFuZCByZXR1cm5zIGFuIGVycm9yCj4+Pj4gLSBW
RklPIGRpc2FibGUgdGhpcyA0dGggdmVjdG9yCj4+Pj4KPj4+PiBJcyB0aGF0IGNvcnJlY3Q/IElm
IHllcywgSSBkb24ndCB1bmRlcnN0YW5kIHdoeSB0aGF0IGltcGFjdHMgdGhlIGd1ZXN0Cj4+Pj4g
YXQgYWxsLiBGcm9tIHdoYXQgSSBjYW4gc2VlLCB2ZmlvX21zaV9zZXRfdmVjdG9yX3NpZ25hbCgp
IGp1c3QgcHJpbnRzCj4+Pj4gYSBtZXNzYWdlIG9uIHRoZSBjb25zb2xlIGFuZCBjYXJyaWVzIG9u
Lgo+Pj4+Cj4+PiBmdW5jdGlvbiBjYWxsczoKPj4+IC0tPiB2ZmlvX21zaV9zZXRfdmVjdG9yX3Np
Z25hbAo+Pj4gICAgIC0tPiBpcnFfYnlwYXNzX3JlZ2lzdGVyX3Byb2R1Y2VyCj4+PiAgICAgICAg
LS0+X19jb25uZWN0Cj4+Pgo+Pj4gaW4gX19jb25uZWN0LCBhZGRfcHJvZHVjZXIgZmluYWxseSBj
YWxscyBrdm1fdmdpY192NF9zZXRfZm9yd2FyZGluZwo+Pj4gYW5kIGZhaWxzIHRvIGdldCB0aGUg
NHRoIG1hcHBpbmcuIFdoZW4gYWRkX3Byb2R1Y2VyIGZhaWwsIGl0IGRvZXMKPj4+IG5vdCBjYWxs
IGNvbnMtPnN0YXJ0LCBjYWxscyBrdm1fYXJjaF9pcnFfYnlwYXNzX3N0YXJ0IGFuZCB0aGVuCj4+
PiBrdm1fYXJtX3Jlc3VtZV9ndWVzdC4KPj4gWytFcmljLCB3aG8gd3JvdGUgdGhlIGlycV9ieXBh
c3MgaW5mcmFzdHJ1Y3R1cmUuXQo+Pgo+PiBBaCwgc28gdGhlIGd1ZXN0IGlzIGFjdHVhbGx5IHBh
dXNlZCwgbm90IGluIGEgbGl2ZWxvY2sgc2l0dWF0aW9uCj4+ICh3aGljaCBpcyBob3cgSSBpbnRl
cnByZXRlZCAic3R1Y2siKS4KPj4KPj4gSSB0aGluayB3ZSBzaG91bGQgaGFuZGxlIHRoaXMgY2Fz
ZSBncmFjZWZ1bGx5LCBhcyB0aGVyZSBzaG91bGQgYmUgbm8KPj4gZXhwZWN0YXRpb24gdGhhdCB0
aGUgZ3Vlc3Qgd2lsbCBiZSB1c2luZyB0aGlzIGludGVycnVwdC4gR2l2ZW4gdGhhdAo+PiBWRklP
IHNlZW1zIHRvIGJlIHByZXR0eSB1bmZhemVkIHdoZW4gYSBwcm9kdWNlciBmYWlscywgSSdtIHRl
bXBlZCB0bwo+PiBkbyB0aGUgc2FtZSB0aGluZyBhbmQgcmVzdGFydCB0aGUgZ3Vlc3QuCj4+Cj4+
IEFsc28sIF9fZGlzY29ubmVjdCBkb2Vzbid0IGNhcmUgYWJvdXQgZXJyb3JzLCBzbyB3aHkgc2hv
dWxkIF9fY29ubmVjdAo+PiBoYXZlIHRoaXMgb2RkIGJlaGF2aW91cj8KPj4KPj4gQ2FuIHlvdSBw
bGVhc2UgdHJ5IHRoaXM/IEl0IGlzIGNvbXBsZXRlbHkgdW50ZXN0ZWQgKGFuZCBJIHRoaW5rIHRo
ZQo+PiBkZWxfY29uc3VtZXIgY2FsbCBpcyBvZGQsIHdoaWNoIGlzIHdoeSBJJ3ZlIGFsc28gZHJv
cHBlZCBpdCkuCj4+Cj4+IEVyaWMsIHdoYXQgZG8geW91IHRoaW5rPwo+IEFkZGluZyBaaHUsIEph
c29uLCBNU1QgdG8gdGhlIHBhcnR5LiBJdCBhbGwgc2VlbXMgdG8gYmUgY2F1c2VkIGJ5IHRoaXMK
PiBjb21taXQ6Cj4KPiBjb21taXQgYTk3OWE2YWEwMDlmM2M5OTY4OTQzMmUwY2RiNTQwMmE0NDYz
ZmI4OAo+IEF1dGhvcjogWmh1IExpbmdzaGFuIDxsaW5nc2hhbi56aHVAaW50ZWwuY29tPgo+IERh
dGU6ICAgRnJpIEp1bCAzMSAxNDo1NTozMyAyMDIwICswODAwCj4KPiAgICAgIGlycWJ5cGFzczog
ZG8gbm90IHN0YXJ0IGNvbnMvcHJvZCB3aGVuIGZhaWxlZCBjb25uZWN0Cj4gICAgICAKPiAgICAg
IElmIGZhaWxlZCB0byBjb25uZWN0LCB0aGVyZSBpcyBubyBuZWVkIHRvIHN0YXJ0IGNvbnN1bWVy
IG5vcgo+ICAgICAgcHJvZHVjZXIuCj4gICAgICAKPiAgICAgIFNpZ25lZC1vZmYtYnk6IFpodSBM
aW5nc2hhbiA8bGluZ3NoYW4uemh1QGludGVsLmNvbT4KPiAgICAgIFN1Z2dlc3RlZC1ieTogSmFz
b24gV2FuZyA8amFzb3dhbmdAcmVkaGF0LmNvbT4KPiAgICAgIExpbms6IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL3IvMjAyMDA3MzEwNjU1MzMuNDE0NC03LWxpbmdzaGFuLnpodUBpbnRlbC5jb20K
PiAgICAgIFNpZ25lZC1vZmYtYnk6IE1pY2hhZWwgUy4gVHNpcmtpbiA8bXN0QHJlZGhhdC5jb20+
Cj4KPgo+IFpodSwgSSdkIHJlYWxseSBsaWtlIHRvIHVuZGVyc3RhbmQgd2h5IHlvdSB0aGluayBp
dCBpcyBPSyBub3QgdG8KPiByZXN0YXJ0IGNvbnN1bWVyIGFuZCBwcm9kdWNlcnMgd2hlbiBhIGNv
bm5lY3Rpb24gaGFzIGZhaWxlZCB0byBiZQo+IGVzdGFibGlzaGVkIGJldHdlZW4gdGhlIHR3bz8K
CgpNeSBiYWQsIEkgZGlkbid0IGNoZWNrIEFSTSBjb2RlIGJ1dCBpdCdzIG5vdCBlYXN5IHRvIGlu
ZmVyIHRoYXQgdGhlIApjb25zLT5zdGFydC9zdG9wIGlzIG5vdCBhIHBlciBjb25zdW1lciBzcGVj
aWZpYyBvcGVyYXRpb24gYnV0IGEgZ2xvYmFsIApvbmUgbGlrZSBWTSBoYWx0aW5nL3Jlc3VtaW5n
LgoKCj4KPiBJbiB0aGUgY2FzZSBvZiBLVk0vYXJtNjQsIHRoaXMgcmVzdWx0cyBpbiB0aGUgZ3Vl
c3QgYmVpbmcgZm9yZXZlcgo+IHN1c3BlbmRlZCBhbmQgbmV2ZXIgcmVzdW1lZC4gVGhhdCdzIG9i
dmlvdXNseSBub3QgYW4gYWNjZXB0YWJsZQo+IHJlZ3Jlc3Npb24sIGFzIHRoZXJlIGlzIGEgbnVt
YmVyIG9mIGJlbmlnbiByZWFzb25zIGZvciBhIGNvbm5lY3QgdG8KPiBmYWlsLgoKCkxldCdzIHJl
dmVydCB0aGlzIGNvbW1pdC4KClRoYW5rcwoKCj4KPiBUaGFua3MsCj4KPiAJTS4KPgoKX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcg
bGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1i
aWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
