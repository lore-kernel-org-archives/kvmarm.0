Return-Path: <SRS0=IuVk=FJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC28C433FE
	for <kvmarm@archiver.kernel.org>; Sat,  5 Dec 2020 18:30:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7477923103
	for <kvmarm@archiver.kernel.org>; Sat,  5 Dec 2020 18:30:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7477923103
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C05CC4B1FB;
	Sat,  5 Dec 2020 13:30:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mI6U-GrgjU3C; Sat,  5 Dec 2020 13:30:25 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C29534B164;
	Sat,  5 Dec 2020 13:30:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AECF84B18A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Dec 2020 13:30:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Cw3yxzCacsS3 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Dec 2020 13:30:23 -0500 (EST)
Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com
 [209.85.221.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CE9A4B118
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Dec 2020 13:30:23 -0500 (EST)
Received: by mail-wr1-f67.google.com with SMTP id x6so4609280wro.11
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Dec 2020 10:30:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=subject:to:cc:references:from:message-id:date:user-agent
 :mime-version:in-reply-to:content-language:content-transfer-encoding;
 bh=WWqB20MHAs7UMnoS0Q6wgVRoNx/aV34/MkacRhfSd2g=;
 b=FqjMFY35Kb8fRgveJIbmJSEnngdTQVOSCs+4B3cuDi3ZkfsNiNGumRrAf8+yrzjVGy
 arUYkhjkyxJdWdkV4eZluhd419jR1LaVgbv4cS0hX2RkpkMXAjWqYk0JG4mHEffhBcPv
 GjYH3w169U7ENGBN2eXElYELND23Ow+AuFRmtwQaIH5PXytG4F/RRe4lCukoJuiDcN3S
 64qRm68NomRD6Cg+1HvMAxjzf6ilu+0vxQropPGcSU8CGHbeu3RBkyQwGpquWbJlBlm7
 5Se6Yw5x3tKgErPatWIsYmWdJeGWIa9MA5a0iqjkHprgq5FMYHWi6sh73m2QQ+If625c
 47VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=WWqB20MHAs7UMnoS0Q6wgVRoNx/aV34/MkacRhfSd2g=;
 b=YeHfOOobM21+8ZwwrreIHsOlCnJtZgevyfcF1OzS5McViK0zvnS8XIYGj7f6H/cucB
 ET0TrdVmJSb/hN3jAI3PQj5U3ut1DLmIlscgaTd7iKHBfcFAeIAGBdPv/c1IykqqZuwu
 wTLcrxv0HcYvM0Ong1DoyIE7CFwMT688MD9wj0KG0gSYre4shXkE+egGsidF4cjkleq8
 OEFD3tLo8EQx6zxc53msp2gXi/eYa8X5pLowcwJCtceebHklg0roGg9yWhazQimFFKKr
 HxzB736VgF3ATs9GUcF0WMgX8P8qKJdRuWBD4RS4rKtEObWNb2P5H3UOKEMeC9K2iSuf
 uCyQ==
X-Gm-Message-State: AOAM533eTwNZZLi3myzP8t140oGSGkbGHo32WT/nzexH3TcDp2otwSn3
 lOrdNl+8nIR+O8hQg/VzKe+9meOn6O+7Vg==
X-Google-Smtp-Source: ABdhPJx/HpX8LbNHK0WAMgBXImoLA/JSSutGQfKGJfblyYzGcfa5RRxbrXAYyzeokwA/L1EWySoLug==
X-Received: by 2002:adf:fdc7:: with SMTP id i7mr9400942wrs.398.1607193022694; 
 Sat, 05 Dec 2020 10:30:22 -0800 (PST)
Received: from ?IPv6:2a01:e34:ed2f:f020:8165:c1cc:d736:b53f?
 ([2a01:e34:ed2f:f020:8165:c1cc:d736:b53f])
 by smtp.googlemail.com with ESMTPSA id h20sm7581744wmb.29.2020.12.05.10.30.21
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Sat, 05 Dec 2020 10:30:21 -0800 (PST)
Subject: Re: [PATCH v3 2/2] clocksource: arm_arch_timer: Correct fault
 programming of CNTKCTL_EL1.EVNTI
To: Marc Zyngier <maz@kernel.org>
References: <20201204073126.6920-1-zhukeqian1@huawei.com>
 <20201204073126.6920-3-zhukeqian1@huawei.com>
 <a82cf9ff-f18d-ce0a-f7a2-82a56cbbec40@linaro.org>
 <ef43679b6710fc4320203975bc2bde98@kernel.org>
From: Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <1ff86943-3f58-b57c-b3db-c3a92af79d2b@linaro.org>
Date: Sat, 5 Dec 2020 19:30:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ef43679b6710fc4320203975bc2bde98@kernel.org>
Content-Language: en-US
Cc: Andrew Morton <akpm@linux-foundation.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Alexios Zavras <alexios.zavras@intel.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

CkhpIE1hcmMsCgpPbiAwNS8xMi8yMDIwIDE5OjIyLCBNYXJjIFp5bmdpZXIgd3JvdGU6Cj4gSGkg
RGFuaWVsLAo+IAo+IE9uIDIwMjAtMTItMDUgMTE6MTUsIERhbmllbCBMZXpjYW5vIHdyb3RlOgo+
PiBIaSBNYXJjLAo+Pgo+PiBhcmUgeW91IGZpbmUgd2l0aCB0aGlzIHBhdGNoID8KPiAKPiBJIGFt
LCBhbHRob3VnaCB0aGVyZSBzdGlsbCBpc24ndCBhbnkganVzdGlmaWNhdGlvbiBmb3IgdGhlIHBv
cy9sc2IKPiByZXdvcmsgaW4gdGhlIGNvbW1pdCBtZXNzYWdlIChhbmQgY2FsbGluZyB0aGF0IHZh
cmlhYmxlIGxzYiBpcyBzb21ld2hhdAo+IGNvbmZ1c2luZykuIElmIHlvdSBhcmUgZ29pbmcgdG8g
YXBwbHkgaXQsIHBsZWFzZSBjb25zaWRlciBhZGRpbmcKPiB0aGUgYWRkaXRpb25hbCBjb21tZW50
IGJlbG93LgoKT2ssIEkgd2lsbCBkbyB0aGF0LgoKVGhhbmtzIGZvciB0aGUgYWRkaXRpb25hbCBj
b21tZW50CgogIC0tIERhbmllbAoKCj4+IE9uIDA0LzEyLzIwMjAgMDg6MzEsIEtlcWlhbiBaaHUg
d3JvdGU6Cj4+PiBBUk0gdmlydHVhbCBjb3VudGVyIHN1cHBvcnRzIGV2ZW50IHN0cmVhbSwgaXQg
Y2FuIG9ubHkgdHJpZ2dlciBhbiBldmVudAo+Pj4gd2hlbiB0aGUgdHJpZ2dlciBiaXQgKHRoZSB2
YWx1ZSBvZiBDTlRLQ1RMX0VMMS5FVk5USSkgb2YgQ05UVkNUX0VMMAo+Pj4gY2hhbmdlcywKPj4+
IHNvIHRoZSBhY3R1YWwgcGVyaW9kIG9mIGV2ZW50IHN0cmVhbSBpcyAyXihjbnRrY3RsX2V2bnRp
ICsgMSkuIEZvcgo+Pj4gZXhhbXBsZSwKPj4+IHdoZW4gdGhlIHRyaWdnZXIgYml0IGlzIDAsIHRo
ZW4gdmlydHVhbCBjb3VudGVyIHRyaWdnZXIgYW4gZXZlbnQgZm9yCj4+PiBldmVyeQo+Pj4gdHdv
IGN5Y2xlcy4KPiAKPiAiV2hpbGUgd2UncmUgYXQgaXQsIHJld29yayB0aGUgd2F5IHdlIGNvbXB1
dGUgdGhlIHRyaWdnZXIgYml0IHBvc2l0aW9uIGJ5Cj4gwqBtYWtpbmcgaXQgbW9yZSBvYnZpb3Vz
IHRoYXQgd2hlbiBiaXRzIFtuOm4tMV0gYXJlIGJvdGggc2V0ICh3aXRoIG4gYmVpbmcKPiDCoHRo
ZSBtb3N0IHNpZ25pZmljYW50IGJpdCksIHdlIHBpY2sgYml0IChuICsgMSkuIgo+IAo+IFdpdGgg
dGhhdDoKPiAKPiBBY2tlZC1ieTogTWFyYyBaeW5naWVyIDxtYXpAa2VybmVsLm9yZz4KPiAKPiBU
aGFua3MsCj4gCj4gwqDCoMKgwqDCoMKgwqAgTS4KCgotLSAKPGh0dHA6Ly93d3cubGluYXJvLm9y
Zy8+IExpbmFyby5vcmcg4pSCIE9wZW4gc291cmNlIHNvZnR3YXJlIGZvciBBUk0gU29DcwoKRm9s
bG93IExpbmFybzogIDxodHRwOi8vd3d3LmZhY2Vib29rLmNvbS9wYWdlcy9MaW5hcm8+IEZhY2Vi
b29rIHwKPGh0dHA6Ly90d2l0dGVyLmNvbS8jIS9saW5hcm9vcmc+IFR3aXR0ZXIgfAo8aHR0cDov
L3d3dy5saW5hcm8ub3JnL2xpbmFyby1ibG9nLz4gQmxvZwpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
