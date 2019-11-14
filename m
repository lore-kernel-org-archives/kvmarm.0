Return-Path: <SRS0=Zv6D=ZG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A73C43215
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 11:06:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC22420709
	for <kvmarm@archiver.kernel.org>; Thu, 14 Nov 2019 11:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC22420709
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27B004AF80;
	Thu, 14 Nov 2019 06:06:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o0DMDjrNv87K; Thu, 14 Nov 2019 06:06:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0584C4AF74;
	Thu, 14 Nov 2019 06:06:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EF904AF70
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 06:06:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z4vjfQya9SqI for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Nov 2019 06:06:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F3124AF6F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Nov 2019 06:06:47 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5D6731B;
 Thu, 14 Nov 2019 03:06:46 -0800 (PST)
Received: from [10.1.194.43] (e112269-lin.cambridge.arm.com [10.1.194.43])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5C883F6C4;
 Thu, 14 Nov 2019 03:06:45 -0800 (PST)
Subject: Re: [PATCH v3 3/3] arm64: Workaround for Cortex-A55 erratum 1530923
To: Suzuki Kuruppassery Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
References: <20191113172252.12610-1-steven.price@arm.com>
 <20191113172252.12610-4-steven.price@arm.com>
 <0b017ec9-5be1-90b9-be30-09462dec9e9d@arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <af9c85ba-4926-7a57-8544-e548b953259e@arm.com>
Date: Thu, 14 Nov 2019 11:06:44 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <0b017ec9-5be1-90b9-be30-09462dec9e9d@arm.com>
Content-Language: en-GB
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 linux-kernel@vger.kernel.org
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

T24gMTQvMTEvMjAxOSAxMDoyNywgU3V6dWtpIEt1cnVwcGFzc2VyeSBQb3Vsb3NlIHdyb3RlOgo+
IE9uIDEzLzExLzIwMTkgMTc6MjIsIFN0ZXZlbiBQcmljZSB3cm90ZToKWy4uLl0KPj4gZGlmZiAt
LWdpdCBhL2FyY2gvYXJtNjQvS2NvbmZpZyBiL2FyY2gvYXJtNjQvS2NvbmZpZwo+PiBpbmRleCBk
ZWZiNjhlNDUzODcuLmQyZGQ3MmMxOTU2MCAxMDA2NDQKPj4gLS0tIGEvYXJjaC9hcm02NC9LY29u
ZmlnCj4+ICsrKyBiL2FyY2gvYXJtNjQvS2NvbmZpZwo+PiBAQCAtNTMyLDYgKzUzMiwxOSBAQCBj
b25maWcgQVJNNjRfRVJSQVRVTV8xMTY1NTIyCj4+IMKgIMKgwqDCoMKgwqDCoMKgIElmIHVuc3Vy
ZSwgc2F5IFkuCj4+IMKgICtjb25maWcgQVJNNjRfRVJSQVRVTV8xNTMwOTIzCj4+ICvCoMKgwqAg
Ym9vbCAiQ29ydGV4LUE1NTogU3BlY3VsYXRpdmUgQVQgaW5zdHJ1Y3Rpb24gdXNpbmcgb3V0LW9m
LWNvbnRleHQKPj4gdHJhbnNsYXRpb24gcmVnaW1lIGNvdWxkIGNhdXNlIHN1YnNlcXVlbnQgcmVx
dWVzdCB0byBnZW5lcmF0ZSBhbgo+PiBpbmNvcnJlY3QgdHJhbnNsYXRpb24iCj4+ICvCoMKgwqAg
ZGVmYXVsdCB5Cj4+ICvCoMKgwqAgc2VsZWN0IEFSTTY0X1dPUktBUk9VTkRfU1BFQ1VMQVRJVkVf
QVQKPiAKPiBBUk02NF9XT1JLQVJPVU5EX1NQRUNVTEFUSVZFX0FUX1ZIRSA/CgpUaGFua3MgZm9y
IHNwb3R0aW5nIC0gYW5ub3lpbmdseSBJIGRvbid0IGV2ZW4gc2VlbSB0byBnZXQgYSB3YXJuaW5n
IGZyb20KS2NvbmZpZyBmb3IgdGhpcy4gSSdsbCBzcGluIGEgdjQgd2l0aCB5b3VyIFItQnMgb24g
dGhlIG90aGVyIHBhdGNoZXMgdG9vCih0aGFua3MgZm9yIHRob3NlIHRvbykuCgpTdGV2ZQpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
