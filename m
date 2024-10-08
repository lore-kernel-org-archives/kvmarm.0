Received: from smtp-fw-52005.amazon.com (smtp-fw-52005.amazon.com [52.119.213.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462947DA76
	for <kvmarm@lists.linux.dev>; Tue,  8 Oct 2024 20:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.119.213.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728419548; cv=none; b=k3i1MyoibQgA7vA6JUNoHHMJnA05UyUTUl7tWMhSmxqbCwzV2yITs2YBGvAtXUWA/SUQc8DYZmYBdjEOQ4XkKV2PuUMRtIpqTdaGd096cRLtOHPZqZ1iOpneZG8PKq2o898jIqKexqvcFAN21y+gCxLtOmL9dswb8HkwAQvRHpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728419548; c=relaxed/simple;
	bh=jdvT/l3GIBbx9cRaKqBLFcB1lZvvW12UILwwbY0Yi6M=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VADuC8R3Lyxb36CXWRTmTV5k/TKV+ZqVd/g/F6VwBO3nns/wJ1Xf9d8UDcmrOyqzFKPgRtfNX9R/Y/+dVzkL4M4oljp0yiXAqf1uE49pD+3JgHz1TQ+9+n0DOoOhh5FZBZ7823blhGyVyYbPQS5FoSynoRQGUB9zxkap5hbDnfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b=OLAdtR9k; arc=none smtp.client-ip=52.119.213.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.de header.i=@amazon.de header.b="OLAdtR9k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1728419546; x=1759955546;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jdvT/l3GIBbx9cRaKqBLFcB1lZvvW12UILwwbY0Yi6M=;
  b=OLAdtR9kiVKz9pnjUQJX8Xh+uDTWZZGQxSc6DcQMConnMMoP5fixsCZC
   TeFtpieiYiaif72aHQSbY6H6NpSFp6A2Oq8GNCrnkUQuCplRcDNwhpJ15
   nDJQBiWJrgUthTN9jvpOs0PZ+aKVbxaVfq9rF3UiPbh9tMNtsFvjlAUy4
   U=;
X-IronPort-AV: E=Sophos;i="6.11,188,1725321600"; 
   d="scan'208";a="686078738"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.43.8.6])
  by smtp-border-fw-52005.iad7.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 20:32:22 +0000
Received: from EX19MTAEUB001.ant.amazon.com [10.0.43.254:21486]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.45.76:2525] with esmtp (Farcaster)
 id 1d7b4ef1-3508-4a12-b398-40fd11dd0028; Tue, 8 Oct 2024 20:32:20 +0000 (UTC)
X-Farcaster-Flow-ID: 1d7b4ef1-3508-4a12-b398-40fd11dd0028
Received: from EX19D007EUB004.ant.amazon.com (10.252.51.85) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.34;
 Tue, 8 Oct 2024 20:32:20 +0000
Received: from EX19MTAUEC001.ant.amazon.com (10.252.135.222) by
 EX19D007EUB004.ant.amazon.com (10.252.51.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1258.35;
 Tue, 8 Oct 2024 20:32:19 +0000
Received: from email-imr-corp-prod-iad-all-1b-8410187a.us-east-1.amazon.com
 (10.43.8.6) by mail-relay.amazon.com (10.252.135.200) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id
 15.2.1258.34 via Frontend Transport; Tue, 8 Oct 2024 20:32:19 +0000
Received: from dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com (dev-dsk-faresx-1b-27755bf1.eu-west-1.amazon.com [10.253.79.181])
	by email-imr-corp-prod-iad-all-1b-8410187a.us-east-1.amazon.com (Postfix) with ESMTPS id 2E0CA406CD;
	Tue,  8 Oct 2024 20:32:17 +0000 (UTC)
From: Fares Mehanna <faresx@amazon.de>
To: <jeffxu@chromium.org>
CC: <akpm@linux-foundation.org>, <ardb@kernel.org>, <arnd@arndb.de>,
	<bhelgaas@google.com>, <broonie@kernel.org>, <catalin.marinas@arm.com>,
	<david@redhat.com>, <faresx@amazon.de>, <james.morse@arm.com>,
	<javierm@redhat.com>, <jean-philippe@linaro.org>, <joey.gouly@arm.com>,
	<keescook@chromium.org>, <kristina.martsenko@arm.com>,
	<kvmarm@lists.linux.dev>, <liam.howlett@oracle.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <mark.rutland@arm.com>, <maz@kernel.org>,
	<nh-open-source@amazon.com>, <oliver.upton@linux.dev>, <ptosi@google.com>,
	<rdunlap@infradead.org>, <rkagan@amazon.de>, <rppt@kernel.org>,
	<shikemeng@huaweicloud.com>, <suzuki.poulose@arm.com>, <tabba@google.com>,
	<will@kernel.org>, <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH 1/7] mseal: expose interface to seal / unseal user memory ranges
Date: Tue, 8 Oct 2024 20:31:48 +0000
Message-ID: <20241008203148.71580-1-faresx@amazon.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <CABi2SkWrQOdxdai7YLoYKKc6GAwxue=jc+bH1=CgE-bKRO-GhA@mail.gmail.com>
References: <CABi2SkWrQOdxdai7YLoYKKc6GAwxue=jc+bH1=CgE-bKRO-GhA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

SGkgSmVmZiwKCj4gSGkgRmFyZXMsCj4gCj4gUGxlYXNlIGFkZCBtZSB0byB0aGlzIHNlcmllcyBh
bmQgSSdtIGludGVyZXN0ZWQgaW4gZXZlcnl0aGluZyByZWxhdGVkCj4gdG8gbXNlYWwgOi0pCj4g
Cj4gSSBhbHNvIGFkZGVkIEtlZXMsIHNpbmNlIG1zZWFsIGlzIGEgc2VjdXJpdHkgZmVhdHVyZSwg
YW5kIGtlZXMgaXMgQ0NlZAo+IG9uIHNlY3VyaXR5IG1hdHRlcnMuCgpUaGFuayB5b3UgZm9yIHRh
a2luZyB0aGUgdGltZSB0byB0YWtlIGEgbG9vayEgU3VyZSBJIHdpbGwgYWRkIHlvdSBib3RoIGlu
IGZ1dHVyZQpSRkNzIGFib3V0IHRoaXMgZmVhdHVyZS4KCj4gT24gV2VkLCBTZXAgMjUsIDIwMjQg
YXQgODoyNeKAr0FNIEZhcmVzIE1laGFubmEgPGZhcmVzeEBhbWF6b24uZGU+IHdyb3RlOgo+ID4K
PiA+IEhpLAo+ID4KPiA+IFRoYW5rcyBmb3IgdGFraW5nIGEgbG9vayBhbmQgYXBvbG9naWVzIGZv
ciBteSBkZWxheWVkIHJlc3BvbnNlLgo+ID4KPiA+ID4gSXQgaXMgbm90IGNsZWFyIGZyb20gdGhl
IGNoYW5nZSBsb2cgYWJvdmUgb3IgdGhlIGNvdmVyIGxldHRlciBhcyB0byB3aHkKPiA+ID4geW91
IG5lZWQgdG8gZ28gdGhpcyByb3V0ZSBpbnN0ZWFkIG9mIHVzaW5nIHRoZSBtbWFwIGxvY2suCj4g
Pgo+ID4gSW4gdGhlIGN1cnJlbnQgZm9ybSBvZiB0aGUgcGF0Y2hlcyBJIHVzZSBtZW1mZF9zZWNy
ZXQoKSB0byBhbGxvY2F0ZSB0aGUgcGFnZXMKPiA+IGFuZCByZW1vdmUgdGhlbSBmcm9tIGtlcm5l
bCBsaW5lYXIgYWRkcmVzcy4gWzFdCj4gPgo+ID4gVGhpcyBhbGxvY2F0ZSBwYWdlcywgbWFwIHRo
ZW0gaW4gdXNlciB2aXJ0dWFsIGFkZHJlc3NlcyBhbmQgdHJhY2sgdGhlbSBpbiBhIFZNQS4KPiA+
Cj4gPiBCZWZvcmUgZmxpcHBpbmcgdGhlIHBlcm1pc3Npb25zIG9uIHRob3NlIHBhZ2VzIHRvIGJl
IHVzZWQgYnkgdGhlIGtlcm5lbCwgSSBuZWVkCj4gPiB0byBtYWtlIHN1cmUgdGhhdCB0aG9zZSB2
aXJ0dWFsIGFkZHJlc3NlcyBhbmQgdGhpcyBWTUEgaXMgb2ZmLWxpbWl0cyB0byB0aGUKPiA+IG93
bmluZyBwcm9jZXNzLgo+ID4KPiA+IG1lbWZkX3NlY3JldCgpIHBhZ2VzIGFyZSBsb2NrZWQgYnkg
ZGVmYXVsdCwgc28gdGhleSB3b24ndCBzd2FwIG91dC4gSSBuZWVkIHRvCj4gPiBzZWFsIHRoZSBW
TUEgdG8gbWFrZSBzdXJlIHRoZSBvd25lciBwcm9jZXNzIGNhbid0IHVubWFwL3JlbWFwLy4uLiBv
ciBjaGFuZ2UgdGhlCj4gPiBwcm90ZWN0aW9uIG9mIHRoaXMgVk1BLgo+ID4KPiA+IFNvIGJlZm9y
ZSBjaGFuZ2luZyB0aGUgcGVybWlzc2lvbnMgb24gdGhlIHNlY3JldCBwYWdlcywgSSBtYWtlIHN1
cmUgdGhlIHBhZ2VzCj4gPiBhcmUgZmF1bHRlZCBpbiwgbG9ja2VkIGFuZCBzZWFsZWQuIFNvIHVz
ZXJzcGFjZSBjYW4ndCBpbmZsdWVuY2UgdGhpcyBtYXBwaW5nLgo+ID4KPiA+ID4gV2UgY2FuJ3Qg
dXNlIHRoZSBtc2VhbCBmZWF0dXJlIGZvciB0aGlzOyBpdCBpcyBzdXBwb3NlZCB0byBiZSBhIG9u
ZSB3YXkKPiA+ID4gdHJhbnNpdGlvbi4KPiA+Cj4gPiBGb3IgdGhpcyBhcHByb2FjaCwgSSBuZWVk
IHRoZSB1bnNlYWwgb3BlcmF0aW9uIHdoZW4gcmVsZWFzaW5nIHRoZSBtZW1vcnkgcmFuZ2UuCj4g
Pgo+ID4gVGhlIGtlcm5lbCBjYW4gYmUgZG9uZSB3aXRoIHRoZSBzZWNyZXQgcGFnZXMgaW4gb25l
IG9mIHR3byBzY2VuYXJpb3M6Cj4gPiAxLiBEdXJpbmcgbGlmZWN5Y2xlIG9mIHRoZSBwcm9jZXNz
Lgo+ID4gMi4gV2hlbiB0aGUgcHJvY2VzcyB0ZXJtaW5hdGVzLgo+ID4KPiA+IEZvciB0aGUgZmly
c3QgY2FzZSwgSSBuZWVkIHRvIHVubWFwIHRoZSBWTUEgc28gaXQgY2FuIGJlIHJldXNlZCBieSB0
aGUgb3duaW5nCj4gPiBwcm9jZXNzIGxhdGVyLCBzbyBJIG5lZWQgdGhlIHVuc2VhbCBvcGVyYXRp
b24uIEZvciB0aGUgc2Vjb25kIGNhc2UgaG93ZXZlciB3ZQo+ID4gZG9uJ3QgbmVlZCB0aGF0IHNp
bmNlIHRoZSBwcm9jZXNzIG1tIGlzIGFscmVhZHkgZGVzdHJ1Y3RlZCBvciBqdXN0IGFib3V0IHRv
IGJlCj4gPiBkZXN0cnVjdGVkIGFueXdheSwgcmVnYXJkbGVzcyBvZiBzZWFsZWQvdW5zZWFsZWQg
Vk1Bcy4gWzFdCj4gPgo+ID4gSSBkaWRuJ3QgZXhwb3NlIHRoZSB1bnNlYWwgb3BlcmF0aW9uIHRv
IHVzZXJzcGFjZS4KPiA+Cj4gSW4gZ2VuZXJhbCwgd2Ugc2hvdWxkIGF2b2lkIGhhdmluZyBkb191
bnNlYWwsIGV2ZW4gdGhvdWdoIHRoZQo+IG9wZXJhdGlvbiBpcyByZXN0cmljdGVkIHRvIHRoZSBr
ZXJuZWwgaXRzZWxmLgo+IAo+IEhvd2V2ZXIsIGZyb20gd2hhdCB5b3UgaGF2ZSBkZXNjcmliZWQs
IHdpdGhvdXQgbG9va2luZyBhdCB5b3VyIGNvZGUsCj4gdGhlIGNhc2UgaXMgY2xvc2VyIHRvIG1z
ZWFsLCBleGNlcHQgdGhhdCB5b3UgbmVlZCB0byB1bm1hcCBpdCB3aXRoaW4KPiB0aGUga2VybmVs
IGNvZGUuCj4gCj4gRm9yIHRoaXMsIHRoZXJlIG1pZ2h0IGJlIHR3byBvcHRpb25zIHRoYXQgSSBj
YW4gdGhpbmsgb2Ygbm93LCBwb3N0Cj4gaGVyZSBmb3IgZGlzY3Vzc2lvbjoKPiAKPiAxPiBBZGQg
YSBuZXcgZmxhZyBpbiB2bV9mbGFncywgdG8gYWxsb3cgdW5tYXAgd2hpbGUgc2VhbGVkLiBIb3dl
dmVyLAo+IHRoaXMgd2lsbCBub3QgcHJldmVudCB1c2VyIHNwYWNlIGZyb20gdW5tYXAgdGhlIGFy
ZWEuCj4gCj4gMj4gcGFzcyBhIGZsYWcgaW4gZG9fdm1pX2FsaWduX211bm1hcCgpIHRvIHNraXAg
c2VhbGluZyBjaGVja3MgZm9yCj4geW91ciBwYXJ0aWN1bGFyIGNhbGwuIFRoZSBkb192bWlfYWxp
Z25fbXVubWFwKCkgYWxyZWFkeSBoYXMgYSBmbGFnCj4gc3VjaCBhcyB1bmxvY2suCj4gCj4gd2ls
bCB0aGUgYWJvdmUgd29yayBmb3IgeW91ciBjYXNlID8gb3IgSSAgbWlzcy11bmRlcnN0b29kIHRo
ZSByZXF1aXJlbWVudC4KClllYWggdGhlIHNlY29uZCBhcHByb2FjaCBpcyBleGFjdGx5IHdoYXQg
SSdtIGxvb2tpbmcgZm9yLCBqdXN0IHRvIHVubWFwIHRoZSBWTUEKd2hpbGUgYmVpbmcgc2VhbGVk
IHRvIGZyZWUgcmVzb3VyY2VzLiBCdXQgSSdtIG5vdCBzdXJlIGhvdyBjb21wbGljYXRlZCBpdCB3
b3VsZApiZSB0byB1c2UuCgpCdXQgSSBnb3QgYSBuZWdhdGl2ZSBmZWVkYmFjayBhYm91dCB0aGUg
d2hvbGUgYXBwcm9hY2ggb2YgdXNpbmcgdXNlciB2YWRkciBhbmQKVk1BcyB0byB0cmFjayBrZXJu
ZWwgc2VjcmV0IGFsbG9jYXRpb25zLiBFdmVuIGlmIEkgY2FuIHRvIGtlZXAgdGhlIFZNQSBvZmYt
bGltaXRzCnRvIHRoZSBvd25pbmcgcHJvY2VzcyBhbmQgcG9zc2libGUgaW1wcm92ZW1lbnQgdG8g
aGlkZSB0aGUgYWN0dWFsIGxvY2F0aW9uIG9mCnRoZSBzZWNyZXQgbWVtb3J5LgoKV2UncmUgc3Rp
bGwgdGhpbmtpbmcgb2YgYSBiZXR0ZXIgYXBwcm9hY2gsIGJ1dCBpZiB3ZSB3ZW50IGJhY2sgdG8g
dGhlIGZpcnN0CmFwcHJvYWNoIG9mIHVzaW5nIHNlcGFyYXRlIFBHRCBpbiBrZXJuZWwgc3BhY2Ug
SSB3b3VsZG4ndCBiZSBtZXNzaW5nIHdpdGggVk1BcwpvciBzZWFsaW5nLgoKVGhhbmtzIQpGYXJl
cy4KCj4gVGhhbmtzCj4gLUplZmYKCgoKQW1hem9uIFdlYiBTZXJ2aWNlcyBEZXZlbG9wbWVudCBD
ZW50ZXIgR2VybWFueSBHbWJICktyYXVzZW5zdHIuIDM4CjEwMTE3IEJlcmxpbgpHZXNjaGFlZnRz
ZnVlaHJ1bmc6IENocmlzdGlhbiBTY2hsYWVnZXIsIEpvbmF0aGFuIFdlaXNzCkVpbmdldHJhZ2Vu
IGFtIEFtdHNnZXJpY2h0IENoYXJsb3R0ZW5idXJnIHVudGVyIEhSQiAyNTc3NjQgQgpTaXR6OiBC
ZXJsaW4KVXN0LUlEOiBERSAzNjUgNTM4IDU5Nwo=

