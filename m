Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0280FC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  9 Dec 2021 08:31:35 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 724594B104;
	Thu,  9 Dec 2021 03:31:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2hk2HBwNYqo8; Thu,  9 Dec 2021 03:31:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 283A84B106;
	Thu,  9 Dec 2021 03:31:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A95C64B104
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 03:31:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iig15gNwOKNa for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Dec 2021 03:31:31 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 061824AC78
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Dec 2021 03:31:30 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1639038690;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=2uvBIC0o3bZPQQpqjTxSxuYUJIG6d5FYvKo3oyhBhNk=;
 b=OJB7awykuk72pX0vjsSdTSRRqhxyJ59nRizK/0OPKZWKXZ2Y9GGDW6j78JJ5eSATlsjzmL
 YLvZ6LELuyTi7M3r/jMMYpOBdMlisViVkl9Imk8VAqEMVl+GrBhiWINiZSRpIm1zmBkTsO
 x7ksEjgWaaaYtyMhE/oUooEEu5jNcDw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-311-Z6dfHk5DML6uFNMt_83I2A-1; Thu, 09 Dec 2021 03:31:28 -0500
X-MC-Unique: Z6dfHk5DML6uFNMt_83I2A-1
Received: by mail-wm1-f71.google.com with SMTP id
 o18-20020a05600c511200b00332fa17a02eso2159689wms.5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Dec 2021 00:31:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:reply-to:subject:to:cc:references:from
 :message-id:date:user-agent:mime-version:in-reply-to
 :content-transfer-encoding:content-language;
 bh=2uvBIC0o3bZPQQpqjTxSxuYUJIG6d5FYvKo3oyhBhNk=;
 b=pMDJBcjjp+5qOg2Wz56OO5nCwGU5XIWrZIB6G4aCKH/aMxl9OJzAYqbYmOCR5McmJC
 /olTpkSOHfDoYPdQCqYR2cohzowg9pAtQHpz/p43/x/BicMK/Iudto1FUWiUW3oi/i4G
 CzA6zEO0lOjec7BvYx9/sBg0MyyAQ+dZC3ZuI40kJIhVGgJr5HrMDLPgkhhOQOSAhphU
 HJNaBGfP+J7beVmDSkcDR1TfKyf62Hs+7RCAHrCwIMYJeMdfu4Do1w5jL4N5B654EZc8
 eDRD/5EavBPv3dV0BI2tZD/jTq2gBaubGSuotMZ/AA9GKnAY8In587f0DOSCPrRoDOGP
 1t3A==
X-Gm-Message-State: AOAM533ylJzRn97jWqq1AY+C18aePp2sgqw9F8UmU2gHmNneAm5ecvvS
 xkOv9VOKQhSJAn6Iy5cr071OJY3NF+1Db5x1hkt3ORCqtod6SHU9XG+epbbzeC1dL7Yeu3WJhxD
 xrjXbAXIKT+AvzWUwl/MazyG6
X-Received: by 2002:a5d:4492:: with SMTP id j18mr4748811wrq.397.1639038686467; 
 Thu, 09 Dec 2021 00:31:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwcFMzZ6oSrHPIkHCcGww2cxWRbpaxmaT3tH/H01UWWsCEBaPG7MIyo4lDX2577yKs6aksMcA==
X-Received: by 2002:a5d:4492:: with SMTP id j18mr4748779wrq.397.1639038686169; 
 Thu, 09 Dec 2021 00:31:26 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874?
 ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
 by smtp.gmail.com with ESMTPSA id f19sm9049910wmq.34.2021.12.09.00.31.24
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Thu, 09 Dec 2021 00:31:25 -0800 (PST)
Subject: Re: [RFC v16 1/9] iommu: Introduce attach/detach_pasid_table API
To: Jason Gunthorpe <jgg@nvidia.com>
References: <20211027104428.1059740-1-eric.auger@redhat.com>
 <20211027104428.1059740-2-eric.auger@redhat.com>
 <Ya3qd6mT/DpceSm8@8bytes.org>
 <c7e26722-f78c-a93f-c425-63413aa33dde@redhat.com>
 <e6733c59-ffcb-74d4-af26-273c1ae8ce68@linux.intel.com>
 <fbeabcff-a6d4-dcc5-6687-7b32d6358fe3@redhat.com>
 <20211208125616.GN6385@nvidia.com>
From: Eric Auger <eric.auger@redhat.com>
Message-ID: <af3530b2-54d2-2807-e783-32110a066c87@redhat.com>
Date: Thu, 9 Dec 2021 09:31:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211208125616.GN6385@nvidia.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=eric.auger@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kevin.tian@intel.com, lushenming@huawei.com, robin.murphy@arm.com,
 ashok.raj@intel.com, kvm@vger.kernel.org, jean-philippe@linaro.org,
 maz@kernel.org, Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
 iommu@lists.linux-foundation.org, vsethi@nvidia.com, vivek.gautam@arm.com,
 alex.williamson@redhat.com, wangxingang5@huawei.com, zhangfei.gao@linaro.org,
 eric.auger.pro@gmail.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 Lu Baolu <baolu.lu@linux.intel.com>
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

SGkgSmFzb24sCgpPbiAxMi84LzIxIDE6NTYgUE0sIEphc29uIEd1bnRob3JwZSB3cm90ZToKPiBP
biBXZWQsIERlYyAwOCwgMjAyMSBhdCAwODozMzozM0FNICswMTAwLCBFcmljIEF1Z2VyIHdyb3Rl
Ogo+PiBIaSBCYW9sdSwKPj4KPj4gT24gMTIvOC8yMSAzOjQ0IEFNLCBMdSBCYW9sdSB3cm90ZToK
Pj4+IEhpIEVyaWMsCj4+Pgo+Pj4gT24gMTIvNy8yMSA2OjIyIFBNLCBFcmljIEF1Z2VyIHdyb3Rl
Ogo+Pj4+IE9uIDEyLzYvMjEgMTE6NDggQU0sIEpvZXJnIFJvZWRlbCB3cm90ZToKPj4+Pj4gT24g
V2VkLCBPY3QgMjcsIDIwMjEgYXQgMTI6NDQ6MjBQTSArMDIwMCwgRXJpYyBBdWdlciB3cm90ZToK
Pj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEplYW4tUGhpbGlwcGUgQnJ1Y2tlcjxqZWFuLXBoaWxpcHBl
LmJydWNrZXJAYXJtLmNvbT4KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IExpdSwgWWkgTDx5aS5sLmxp
dUBsaW51eC5pbnRlbC5jb20+Cj4+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBBc2hvayBSYWo8YXNob2su
cmFqQGludGVsLmNvbT4KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEphY29iIFBhbjxqYWNvYi5qdW4u
cGFuQGxpbnV4LmludGVsLmNvbT4KPj4+Pj4+IFNpZ25lZC1vZmYtYnk6IEVyaWMgQXVnZXI8ZXJp
Yy5hdWdlckByZWRoYXQuY29tPgo+Pj4+PiBUaGlzIFNpZ25lZC1vZi1ieSBjaGFpbiBsb29rcyBk
dWJpb3VzLCB5b3UgYXJlIHRoZSBhdXRob3IgYnV0IHRoZSBsYXN0Cj4+Pj4+IG9uZSBpbiB0aGUg
Y2hhaW4/Cj4+Pj4gVGhlIDFzdCBSRkMgaW4gQXVnIDIwMTgKPj4+PiAoaHR0cHM6Ly9saXN0cy5j
cy5jb2x1bWJpYS5lZHUvcGlwZXJtYWlsL2t2bWFybS8yMDE4LUF1Z3VzdC8wMzI0NzguaHRtbCkK
Pj4+PiBzYWlkIHRoaXMgd2FzIGEgZ2VuZXJhbGl6YXRpb24gb2YgSmFjb2IncyBwYXRjaAo+Pj4+
Cj4+Pj4KPj4+PiDCoMKgIFtQQVRDSCB2NSAwMS8yM10gaW9tbXU6IGludHJvZHVjZSBiaW5kX3Bh
c2lkX3RhYmxlIEFQSSBmdW5jdGlvbgo+Pj4+Cj4+Pj4KPj4+PiDCoMKgCj4+Pj4gaHR0cHM6Ly9s
aXN0cy5saW51eGZvdW5kYXRpb24ub3JnL3BpcGVybWFpbC9pb21tdS8yMDE4LU1heS8wMjc2NDcu
aHRtbAo+Pj4+Cj4+Pj4gU28gaW5kZWVkIEphY29iIHNob3VsZCBiZSB0aGUgYXV0aG9yLiBJIGd1
ZXNzIHRoZSBtdWx0aXBsZSByZWJhc2VzIGdvdAo+Pj4+IHRoaXMgZXZlbnR1YWxseSByZXBsYWNl
ZCBhdCBzb21lIHBvaW50LCB3aGljaCBpcyBub3QgYW4gZXhjdXNlLiBQbGVhc2UKPj4+PiBmb3Jn
aXZlIG1lIGZvciB0aGF0Lgo+Pj4+IE5vdyB0aGUgb3JpZ2luYWwgcGF0Y2ggYWxyZWFkeSBoYWQg
dGhpcyBsaXN0IG9mIFNvQiBzbyBJIGRvbid0IGtub3cgaWYgSQo+Pj4+IHNoYWxsIHNpbXBsaWZ5
IGl0Lgo+Pj4gQXMgd2UgaGF2ZSBkZWNpZGVkIHRvIG1vdmUgdGhlIG5lc3RlZCBtb2RlIChkdWFs
IHN0YWdlcykgaW1wbGVtZW50YXRpb24KPj4+IG9udG8gdGhlIGRldmVsb3BpbmcgaW9tbXVmZCBm
cmFtZXdvcmssIHdoYXQncyB0aGUgdmFsdWUgb2YgYWRkaW5nIHRoaXMKPj4+IGludG8gaW9tbXUg
Y29yZT8KPj4gVGhlIGlvbW11X3VhcGlfYXR0YWNoX3Bhc2lkX3RhYmxlIHVhcGkgc2hvdWxkIGRp
c2FwcGVhciBpbmRlZWQgYXMgaXQgaXMKPj4gaXMgYm91bmQgdG8gYmUgcmVwbGFjZWQgYnkgL2Rl
di9pb21tdSBmZWxsb3cgQVBJLgo+PiBIb3dldmVyIHVudGlsIEkgY2FuIHJlYmFzZSBvbiAvZGV2
L2lvbW11IGNvZGUgSSBhbSBvYmxpZ2VkIHRvIGtlZXAgaXQgdG8KPj4gbWFpbnRhaW4gdGhpcyBp
bnRlZ3JhdGlvbiwgaGVuY2UgdGhlIFJGQy4KPiBJbmRlZWQsIHdlIGFyZSBnZXR0aW5nIHByZXR0
eSBjbG9zZSB0byBoYXZpbmcgdGhlIGJhc2UgaW9tbXVmZCB0aGF0IHdlCj4gY2FuIHN0YXJ0IGFk
ZGluZyBzdHVmZiBsaWtlIHRoaXMgaW50by4gTWF5YmUgaW4gSmFudWFyeSwgeW91IGNhbiBsb29r
Cj4gYXQgc29tZSBwYXJ0cyBvZiB3aGF0IGlzIGV2b2x2aW5nIGhlcmU6Cj4KPiBodHRwczovL2dp
dGh1Yi5jb20vamd1bnRob3JwZS9saW51eC9jb21taXRzL2lvbW11ZmQKPiBodHRwczovL2dpdGh1
Yi5jb20vTHVCYW9sdS9pbnRlbC1pb21tdS9jb21taXRzL2lvbW11LWRtYS1vd25lcnNoaXAtdjIK
PiBodHRwczovL2dpdGh1Yi5jb20vbHV4aXMxOTk5L2lvbW11ZmQvY29tbWl0cy9pb21tdWZkLXY1
LjE2LXJjMgpJbnRlcmVzdGluZy4gdGhhbmsgeW91IGZvciB0aGUgcHJldmlldyBsaW5rcy4gSSB3
aWxsIGhhdmUgYSBsb29rIGFzYXAKCkVyaWMKPgo+IEZyb20gYSBwcm9ncmVzcyBwZXJzcGVjdGl2
ZSBJIHdvdWxkIGxpa2UgdG8gc3RhcnQgd2l0aCBzaW1wbGUgJ3BhZ2UKPiB0YWJsZXMgaW4gdXNl
cnNwYWNlJywgaWUgbm8gUEFTSUQgaW4gdGhpcyBzdGVwLgo+Cj4gJ3BhZ2UgdGFibGVzIGluIHVz
ZXJzcGFjZScgbWVhbnMgYW4gaW9tbXVmZCBpb2N0bCB0byBjcmVhdGUgYW4KPiBpb21tdV9kb21h
aW4gd2hlcmUgdGhlIElPTU1VIEhXIGlzIGRpcmVjdGx5IHRyYXZlc2VyaW5nIGEKPiBkZXZpY2Ut
c3BlY2lmaWMgcGFnZSB0YWJsZSBzdHJ1Y3R1cmUgaW4gdXNlciBzcGFjZSBtZW1vcnkuIEFsbCB0
aGUgSFcKPiB0b2RheSBpbXBsZW1lbnRzIHRoaXMgYnkgdXNpbmcgYW5vdGhlciBpb21tdV9kb21h
aW4gdG8gYWxsb3cgdGhlIElPTU1VCj4gSFcgRE1BIGFjY2VzcyB0byB1c2VyIG1lbW9yeSAtIGll
IG5lc3Rpbmcgb3IgbXVsdGktc3RhZ2Ugb3Igd2hhdGV2ZXIuCj4KPiBUaGlzIHdvdWxkIGNvbWUg
YWxvbmcgd2l0aCBzb21lIGlvY3RscyB0byBpbnZhbGlkYXRlIHRoZSBJT1RMQi4KPgo+IEknbSBp
bWFnaW5pbmcgdGhpcyBzdGVwIGFzIGEgaW9tbXVfZ3JvdXAtPm9wLT5jcmVhdGVfdXNlcl9kb21h
aW4oKQo+IGRyaXZlciBjYWxsYmFjayB3aGljaCB3aWxsIGNyZWF0ZSBhIG5ldyBraW5kIG9mIGRv
bWFpbiB3aXRoCj4gZG9tYWluLXVuaXF1ZSBvcHMuIEllIG1hcC91bm1hcCByZWxhdGVkIHNob3Vs
ZCBhbGwgYmUgTlVMTCBhcyB0aG9zZQo+IGFyZSBpbXBvc3NpYmxlIG9wZXJhdGlvbnMuCj4KPiBG
cm9tIHRoZXJlIHRoZSB1c3VhbCBzdHJ1Y3QgZGV2aWNlIChpZSBSSUQpIGF0dGFjaC9kZXRhdGNo
IHN0dWZmIG5lZWRzCj4gdG8gdGFrZSBjYXJlIG9mIHJvdXRpbmcgRE1BcyB0byB0aGlzIGlvbW11
X2RvbWFpbi4KPgo+IFN0ZXAgdHdvIHdvdWxkIGJlIHRvIGFkZCB0aGUgYWJpbGl0eSBmb3IgYW4g
aW9tbXVmZCB1c2luZyBkcml2ZXIgdG8KPiByZXF1ZXN0IHRoYXQgYSBSSUQmUEFTSUQgaXMgY29u
bmVjdGVkIHRvIGFuIGlvbW11X2RvbWFpbi4gVGhpcwo+IGNvbm5lY3Rpb24gY2FuIGJlIHJlcXVl
c3RlZCBmb3IgYW55IGtpbmQgb2YgaW9tbXVfZG9tYWluLCBrZXJuZWwgb3duZWQKPiBvciB1c2Vy
IG93bmVkLgo+Cj4gSSBkb24ndCBxdWl0ZSBoYXZlIGFuIGFuc3dlciBob3cgZXhhY3RseSB0aGUg
U01NVXYzIHZzIEludGVsCj4gZGlmZmVyZW5jZSBpbiBQQVNJRCByb3V0aW5nIHNob3VsZCBiZSBy
ZXNvbHZlZC4KPgo+IHRvIGdldCBhbnN3ZXJzIEknbSBob3BpbmcgdG8gc3RhcnQgYnVpbGRpbmcg
c29tZSBza2V0Y2ggUkZDcyBmb3IgdGhlc2UKPiBkaWZmZXJlbnQgdGhpbmdzIG9uIGlvbW11ZmQs
IGhvcGVmdWxseSBpbiBKYW51YXJ5LiBJJ20gbG9va2luZyBhdCB1c2VyCj4gcGFnZSB0YWJsZXMs
IFBBU0lELCBkaXJ0eSB0cmFja2luZyBhbmQgdXNlcnNwYWNlIElPIGZhdWx0IGhhbmRsaW5nIGFz
Cj4gdGhlIG1haW4gZmVhdHVyZXMgaW9tbXVmZCBtdXN0IHRhY2tsZS4KPgo+IFRoZSBwdXJwb3Nl
IG9mIHRoZSBza2V0Y2hlcyB3b3VsZCBiZSB0byB2YWxpZGF0ZSB0aGF0IHRoZSBIVyBmZWF0dXJl
cwo+IHdlIHdhbnQgdG8gZXhwb3NlZCBjYW4gd29yayB3aWxsIHdpdGggdGhlIGNob2ljZXMgdGhl
IGJhc2UgaXMgbWFraW5nLgo+Cj4gSmFzb24KPgoKX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3Mu
Y29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGlu
Zm8va3ZtYXJtCg==
