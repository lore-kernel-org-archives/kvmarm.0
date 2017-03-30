From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [kvmtool PATCH v9 06/15] PCI: Only allocate IRQ routing entry
 when available
Date: Thu, 30 Mar 2017 08:29:34 +0100
Message-ID: <87k277ql29.fsf@on-the-bus.cambridge.arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
 <20170202163223.15372-7-andre.przywara@arm.com>
 <d26dea9f-386b-316c-a2b3-d42ea1883997@arm.com>
 <6371fdda-bdd5-2aa0-de8c-4f97953ee326@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA3F940190
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 03:27:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uWyvGygAqIX5 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Mar 2017 03:27:39 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CE79400E9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Mar 2017 03:27:39 -0400 (EDT)
In-Reply-To: <6371fdda-bdd5-2aa0-de8c-4f97953ee326@arm.com> (=?utf-8?Q?=22?=
 =?utf-8?Q?Andr=C3=A9?=
 Przywara"'s message of "Wed, 29 Mar 2017 21:44:47 +0100")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?utf-8?Q?Andr=C3=A9?= Przywara <andre.przywara@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

T24gV2VkLCBNYXIgMjkgMjAxNyBhdCAgOTo0NDo0NyBwbSBCU1QsIEFuZHLDqSBQcnp5d2FyYSA8
YW5kcmUucHJ6eXdhcmFAYXJtLmNvbT4gd3JvdGU6Cj4gSGkgTWFyYywKPgo+IHRoYW5rcyBmb3Ig
aGF2aW5nIGEgbG9vayEKPgo+IE9uIDI5LzAzLzE3IDA5OjMwLCBNYXJjIFp5bmdpZXIgd3JvdGU6
Cj4+IE9uIDAyLzAyLzE3IDE2OjMyLCBBbmRyZSBQcnp5d2FyYSB3cm90ZToKPj4+IElmIHdlIG5l
ZWQgdG8gaW5qZWN0IGFuIE1TSSBpbnRvIHRoZSBndWVzdCwgd2UgcmVseSBhdCB0aGUgbW9tZW50
IG9uIGEKPj4+IHdvcmtpbmcgR1NJIE1TSSByb3V0aW5nIGZ1bmN0aW9uYWxpdHkuIEhvd2V2ZXIg
d2UgY2FuIGdldCBhd2F5IHdpdGhvdXQKPj4+IElSUSByb3V0aW5nLCBpZiB0aGUgaG9zdCBzdXBw
b3J0cyBNU0kgaW5qZWN0aW9uIHZpYSB0aGUgS1ZNX1NJR05BTF9NU0kKPj4+IGlvY3RsLgo+Pj4g
U28gd2UgdHJ5IHRoZSBHU0kgcm91dGluZyBmaXJzdCwgYnV0IGlmIHRoYXQgZmFpbHMgZHVlIHRv
IGEgbWlzc2luZwo+Pj4gSVJRIHJvdXRpbmcgZnVuY3Rpb25hbGl0eSwgd2UgZmFsbCBiYWNrIHRv
IEtWTV9TSUdOQUxfTVNJIChpZiB0aGF0IGlzCj4+PiBzdXBwb3J0ZWQpLgo+Pj4KPj4+IFNpZ25l
ZC1vZmYtYnk6IEFuZHJlIFByenl3YXJhIDxhbmRyZS5wcnp5d2FyYUBhcm0uY29tPgo+Pj4gLS0t
Cj4+PiAgdmlydGlvL3BjaS5jIHwgMTYgKysrKysrKysrKysrKystLQo+Pj4gIDEgZmlsZSBjaGFu
Z2VkLCAxNCBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQo+Pj4KPj4+IGRpZmYgLS1naXQg
YS92aXJ0aW8vcGNpLmMgYi92aXJ0aW8vcGNpLmMKPj4+IGluZGV4IDdjYzBiYTQuLjk4YmY2Yjcg
MTAwNjQ0Cj4+PiAtLS0gYS92aXJ0aW8vcGNpLmMKPj4+ICsrKyBiL3ZpcnRpby9wY2kuYwo+Pj4g
QEAgLTE5Myw4ICsxOTMsMTQgQEAgc3RhdGljIGJvb2wgdmlydGlvX3BjaV9fc3BlY2lmaWNfaW9f
b3V0KHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IHZpcnRpb19kZXZpY2UgKnYKPj4+ICAKPj4+ICAJ
CQlnc2kgPSBpcnFfX2FkZF9tc2l4X3JvdXRlKGt2bSwKPj4+ICAJCQkJCQkgICZ2cGNpLT5tc2l4
X3RhYmxlW3ZlY10ubXNnKTsKPj4+IC0JCQlpZiAoZ3NpID49IDApCj4+PiArCQkJaWYgKGdzaSA+
PSAwKSB7Cj4+PiAgCQkJCXZwY2ktPmNvbmZpZ19nc2kgPSBnc2k7Cj4+PiArCQkJCWJyZWFrOwo+
Pj4gKwkJCX0KPj4+ICsJCQlpZiAoZ3NpID09IC1FTlhJTyAmJgo+Pj4gKwkJCSAgICB2cGNpLT5m
ZWF0dXJlcyAmIFZJUlRJT19QQ0lfRl9TSUdOQUxfTVNJKQo+Pj4gKwkJCQkJYnJlYWs7Cj4+PiAr
CQkJZGllKCJmYWlsZWQgdG8gY29uZmlndXJlIE1TSXMiKTsKPj4+ICAJCQlicmVhazsKPj4+ICAJ
CWNhc2UgVklSVElPX01TSV9RVUVVRV9WRUNUT1I6Cj4+PiAgCQkJdmVjID0gaW9wb3J0X19yZWFk
MTYoZGF0YSk7Cj4+PiBAQCAtMjA1LDggKzIxMSwxNCBAQCBzdGF0aWMgYm9vbCB2aXJ0aW9fcGNp
X19zcGVjaWZpY19pb19vdXQoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3QgdmlydGlvX2RldmljZSAq
dgo+Pj4gIAo+Pj4gIAkJCWdzaSA9IGlycV9fYWRkX21zaXhfcm91dGUoa3ZtLAo+Pj4gIAkJCQkJ
CSAgJnZwY2ktPm1zaXhfdGFibGVbdmVjXS5tc2cpOwo+Pj4gLQkJCWlmIChnc2kgPCAwKQo+Pj4g
KwkJCWlmIChnc2kgPCAwKSB7Cj4+PiArCQkJCWlmIChnc2kgPT0gLUVOWElPICYmCj4+PiArCQkJ
CSAgICB2cGNpLT5mZWF0dXJlcyAmIFZJUlRJT19QQ0lfRl9TSUdOQUxfTVNJKQo+Pj4gKwkJCQkJ
YnJlYWs7Cj4+PiArCj4+PiArCQkJCWRpZSgiZmFpbGVkIHRvIGNvbmZpZ3VyZSBNU0lzIik7Cj4+
PiAgCQkJCWJyZWFrOwo+Pj4gKwkJCX0KPj4+ICAJCQl2cGNpLT5nc2lzW3ZwY2ktPnF1ZXVlX3Nl
bGVjdG9yXSA9IGdzaTsKPj4gCj4+IElzIGl0IHJlYWxseSBleHBlY3RlZCB0byBmaW5kIC1FTlhJ
TyBpbiB0aGlzIGFycmF5IGluc3RlYWQgb2YgYSBHU0k/Cj4KPiBOb3Qgc3VyZSBJIGdldCB0aGlz
ICJpbiB0aGlzIGFycmF5IiBjb21tZW50IGhlcmUuIEFueSBuZWdhdGl2ZSByZXR1cm4KPiB2YWx1
ZSBlbmRzIHVwIGluIGEgYnJlYWssIHdpdGhvdXQgd3JpdGluZyBpdCBhbnl3aGVyZS4KPiBMYXRl
ciBvbiB3ZSBjaGVjayBmb3IgVklSVElPX1BDSV9GX1NJR05BTF9NU0kgZmlyc3QgYmVmb3JlIHJl
ZmVyZW5jaW5nCj4gdGhlIGFycmF5LiBUaGlzIGlzIGFkbWl0dGVkbHkgYSBiaXQgY29udm9sdXRl
ZC4KPiBTbyBzaGFsbCBJIGFkZCBjb21tZW50cyBoZXJlPyBPciByZXdyaXRlIHRoZSBpZiBzdGF0
ZW1lbnQgdG8gbWFrZSB0aGlzCj4gbW9yZSBvYnZpb3VzPwoKQWghIE9mIGNvdXJzZSB5b3UncmUg
cmlnaHQsIEkgY29tcGxldGVseSBtaXNyZWFkIHRoZSBjb2RlLiBNYXliZSBpbmRlZWQKcmV3cml0
aW5nIGEgYml0IHRvIG1ha2UgaXQgbW9yZSBvYnZpb3VzOgoKCWlmIChnc2kgPT0gLUVOWElPICYm
IHZwY2ktPmZlYXR1cmVzICYgVklSVElPX1BDSV9GX1NJR05BTF9NU0kpCgkJYnJlYWs7CiAgICAg
ICAgaWYgKGdzaSA8IDApIHsKICAgICAgICAJZGllKCJmYWlsZWQgdG8gY29uZmlndXJlIE1TSXMi
KTsKICAgICAgICAgICAgICAgIGJyZWFrCiAgICAgICAgfQoKd2hpY2ggaXMgY2xvc2VyIHRvIHRo
ZSBmaXJzdC4KClRoYW5rcywKCglNLgotLSAKSmF6eiBpcyBub3QgZGVhZCwgaXQganVzdCBzbWVs
bCBmdW5ueS4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18K
a3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8v
bGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
