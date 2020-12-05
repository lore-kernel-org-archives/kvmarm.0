Return-Path: <SRS0=IuVk=FJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1097AC4361A
	for <kvmarm@archiver.kernel.org>; Sat,  5 Dec 2020 11:15:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 70F7222D6F
	for <kvmarm@archiver.kernel.org>; Sat,  5 Dec 2020 11:15:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70F7222D6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D05474B15B;
	Sat,  5 Dec 2020 06:15:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YeelUHonGqm3; Sat,  5 Dec 2020 06:15:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC9FA4B184;
	Sat,  5 Dec 2020 06:15:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 024BA4B15B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Dec 2020 06:15:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VFOrqkthdMVw for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Dec 2020 06:15:05 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7ED864B10C
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Dec 2020 06:15:05 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id 91so3865183wrj.7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Dec 2020 03:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=vm0kTYRfsbbw/uXa2uKVACoRIfxCWD5Snf9/ZZBS4vI=;
 b=Yr1ZIzDR77DcgbQbUxzYZI0kWHLoTvxPJi6yJox554/E5iE4d4BfyXrcjh9kQanIFl
 7NUcFENYX8B+GnaTBmEk6JDJKwmS3wq9B0aXsIA8x8tpTNywbdy33TOjYqbDxWKM/e5Q
 GRv5p43UpM6pr6oc14g2NF+YOtjmyBxBAasEiVBayB1JolLmXIoOUQwDotq0qLvYgOEH
 eFPxAA3AeVwMsrNQr85hrxbLRcNd892rbKdnEljiKEWwEbUKYagkfFOxrGz4Htc+Iwaw
 sFsVJz1U5Y6deBeak6EVLnN/0xjRCdFKrdESHIIoBJu1LHenlWG1SSleFpgFQYpnxFZ6
 fQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=vm0kTYRfsbbw/uXa2uKVACoRIfxCWD5Snf9/ZZBS4vI=;
 b=dsaWGtmgvQlv8KwVb7w6+/e8K0SArQF1m/RPv0v/qcYNMisL6OLb57FlH4UvK+LJZM
 JaDZ9WjAhKLioSIB36rO/Bj+UlqfNIwHfzaYqXEYQKBP7SsQY5LWaZSYKWOTYFRmxr2C
 7Doo490WCaw8gkqGC9pv8gMPzYkuV2lkT7sY3JfPSJi1ww2s3217e/GTRScoahbudlkv
 ta/Cbhh0GL26cHsjg/Q8SolIVOZaRG0ddmdDtXoE1zMRq5e3mwWcVMQT1Z3lIiLdzOQM
 gNl6f84uUDdZj2QIE9RCCqBb+202lGVaM61i3IuIN/BKpeHTThQsm4pDVDSgIGnf2Kxf
 2qFg==
X-Gm-Message-State: AOAM530MKnY3kSG5b51XBIkZlVJP9xvSSHPy8uy8K6Wmk7oj9q7dJ2Dc
 Hgdj/JlTwzch/Ptm63TzPOF8Wg==
X-Google-Smtp-Source: ABdhPJzidHN37LYdbiTj7YPUSYlEeuJWU1/5ZyiN4M4YFSu2jXb2xdJ0Tww0x7DtBdcHudzvJvASzA==
X-Received: by 2002:adf:a3d1:: with SMTP id m17mr9487100wrb.289.1607166904041; 
 Sat, 05 Dec 2020 03:15:04 -0800 (PST)
Received: from ?IPv6:2a01:e34:ed2f:f020:8165:c1cc:d736:b53f?
 ([2a01:e34:ed2f:f020:8165:c1cc:d736:b53f])
 by smtp.googlemail.com with ESMTPSA id a65sm6470758wmc.35.2020.12.05.03.15.02
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 05 Dec 2020 03:15:03 -0800 (PST)
Subject: Re: [PATCH v3 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
To: Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20201204073126.6920-1-zhukeqian1@huawei.com>
 <20201204073126.6920-3-zhukeqian1@huawei.com>
From: Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <a82cf9ff-f18d-ce0a-f7a2-82a56cbbec40@linaro.org>
Date: Sat, 5 Dec 2020 12:15:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201204073126.6920-3-zhukeqian1@huawei.com>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
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

CgpIaSBNYXJjLAoKYXJlIHlvdSBmaW5lIHdpdGggdGhpcyBwYXRjaCA/CgoKT24gMDQvMTIvMjAy
MCAwODozMSwgS2VxaWFuIFpodSB3cm90ZToKPiBBUk0gdmlydHVhbCBjb3VudGVyIHN1cHBvcnRz
IGV2ZW50IHN0cmVhbSwgaXQgY2FuIG9ubHkgdHJpZ2dlciBhbiBldmVudAo+IHdoZW4gdGhlIHRy
aWdnZXIgYml0ICh0aGUgdmFsdWUgb2YgQ05US0NUTF9FTDEuRVZOVEkpIG9mIENOVFZDVF9FTDAg
Y2hhbmdlcywKPiBzbyB0aGUgYWN0dWFsIHBlcmlvZCBvZiBldmVudCBzdHJlYW0gaXMgMl4oY250
a2N0bF9ldm50aSArIDEpLiBGb3IgZXhhbXBsZSwKPiB3aGVuIHRoZSB0cmlnZ2VyIGJpdCBpcyAw
LCB0aGVuIHZpcnR1YWwgY291bnRlciB0cmlnZ2VyIGFuIGV2ZW50IGZvciBldmVyeQo+IHR3byBj
eWNsZXMuCj4gCj4gRml4ZXM6IDAzN2Y2Mzc3NjdhOCAoImRyaXZlcnM6IGNsb2Nrc291cmNlOiBh
ZGQgc3VwcG9ydCBmb3IgQVJNIGFyY2hpdGVjdGVkIHRpbWVyIGV2ZW50IHN0cmVhbSIpCj4gU3Vn
Z2VzdGVkLWJ5OiBNYXJjIFp5bmdpZXIgPG1hekBrZXJuZWwub3JnPgo+IFNpZ25lZC1vZmYtYnk6
IEtlcWlhbiBaaHUgPHpodWtlcWlhbjFAaHVhd2VpLmNvbT4KPiAtLS0KPiAgZHJpdmVycy9jbG9j
a3NvdXJjZS9hcm1fYXJjaF90aW1lci5jIHwgMjMgKysrKysrKysrKysrKysrKy0tLS0tLS0KPiAg
MSBmaWxlIGNoYW5nZWQsIDE2IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCj4gCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuYyBiL2RyaXZlcnMv
Y2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuYwo+IGluZGV4IDc3N2QzOGNiMzliMC4uZDAxNzc4
MjRjNTE4IDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIu
Ywo+ICsrKyBiL2RyaXZlcnMvY2xvY2tzb3VyY2UvYXJtX2FyY2hfdGltZXIuYwo+IEBAIC04MjIs
MTUgKzgyMiwyNCBAQCBzdGF0aWMgdm9pZCBhcmNoX3RpbWVyX2V2dHN0cm1fZW5hYmxlKGludCBk
aXZpZGVyKQo+ICAKPiAgc3RhdGljIHZvaWQgYXJjaF90aW1lcl9jb25maWd1cmVfZXZ0c3RyZWFt
KHZvaWQpCj4gIHsKPiAtCWludCBldnRfc3RyZWFtX2RpdiwgcG9zOwo+ICsJaW50IGV2dF9zdHJl
YW1fZGl2LCBsc2I7Cj4gKwo+ICsJLyoKPiArCSAqIEFzIHRoZSBldmVudCBzdHJlYW0gY2FuIGF0
IG1vc3QgYmUgZ2VuZXJhdGVkIGF0IGhhbGYgdGhlIGZyZXF1ZW5jeQo+ICsJICogb2YgdGhlIGNv
dW50ZXIsIHVzZSBoYWxmIHRoZSBmcmVxdWVuY3kgd2hlbiBjb21wdXRpbmcgdGhlIGRpdmlkZXIu
Cj4gKwkgKi8KPiArCWV2dF9zdHJlYW1fZGl2ID0gYXJjaF90aW1lcl9yYXRlIC8gQVJDSF9USU1F
Ul9FVlRfU1RSRUFNX0ZSRVEgLyAyOwo+ICsKPiArCS8qCj4gKwkgKiBGaW5kIHRoZSBjbG9zZXN0
IHBvd2VyIG9mIHR3byB0byB0aGUgZGl2aXNvci4gSWYgdGhlIGFkamFjZW50IGJpdAo+ICsJICog
b2YgbHNiIChsYXN0IHNldCBiaXQsIHN0YXJ0cyBmcm9tIDApIGlzIHNldCwgdGhlbiB3ZSB1c2Ug
KGxzYiArIDEpLgo+ICsJICovCj4gKwlsc2IgPSBmbHMoZXZ0X3N0cmVhbV9kaXYpIC0gMTsKPiAr
CWlmIChsc2IgPiAwICYmIChldnRfc3RyZWFtX2RpdiAmIEJJVChsc2IgLSAxKSkpCj4gKwkJbHNi
Kys7Cj4gIAo+IC0JLyogRmluZCB0aGUgY2xvc2VzdCBwb3dlciBvZiB0d28gdG8gdGhlIGRpdmlz
b3IgKi8KPiAtCWV2dF9zdHJlYW1fZGl2ID0gYXJjaF90aW1lcl9yYXRlIC8gQVJDSF9USU1FUl9F
VlRfU1RSRUFNX0ZSRVE7Cj4gLQlwb3MgPSBmbHMoZXZ0X3N0cmVhbV9kaXYpOwo+IC0JaWYgKHBv
cyA+IDEgJiYgIShldnRfc3RyZWFtX2RpdiAmICgxIDw8IChwb3MgLSAyKSkpKQo+IC0JCXBvcy0t
Owo+ICAJLyogZW5hYmxlIGV2ZW50IHN0cmVhbSAqLwo+IC0JYXJjaF90aW1lcl9ldnRzdHJtX2Vu
YWJsZShtaW4ocG9zLCAxNSkpOwo+ICsJYXJjaF90aW1lcl9ldnRzdHJtX2VuYWJsZShtYXgoMCwg
bWluKGxzYiwgMTUpKSk7Cj4gIH0KPiAgCj4gIHN0YXRpYyB2b2lkIGFyY2hfY291bnRlcl9zZXRf
dXNlcl9hY2Nlc3Modm9pZCkKPiAKCgotLSAKPGh0dHA6Ly93d3cubGluYXJvLm9yZy8+IExpbmFy
by5vcmcg4pSCIE9wZW4gc291cmNlIHNvZnR3YXJlIGZvciBBUk0gU29DcwoKRm9sbG93IExpbmFy
bzogIDxodHRwOi8vd3d3LmZhY2Vib29rLmNvbS9wYWdlcy9MaW5hcm8+IEZhY2Vib29rIHwKPGh0
dHA6Ly90d2l0dGVyLmNvbS8jIS9saW5hcm9vcmc+IFR3aXR0ZXIgfAo8aHR0cDovL3d3dy5saW5h
cm8ub3JnL2xpbmFyby1ibG9nLz4gQmxvZwpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1
bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9r
dm1hcm0K
