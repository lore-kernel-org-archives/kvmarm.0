Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61952C433DB
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 10:04:09 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CBE512368A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 10:04:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBE512368A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FF2A4B37D;
	Fri,  8 Jan 2021 05:04:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id OAkAMoQex8pe; Fri,  8 Jan 2021 05:04:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1185F4B383;
	Fri,  8 Jan 2021 05:04:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE3DF4B37F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 05:04:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vReRUa+ME2wb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 05:04:05 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 213B64B37D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 05:04:05 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1610100244;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=11l3mj1UE5jX79PBsPyiLxVECs3/fF4MoveQY9G6pbQ=;
 b=isUoiQeX5ZWiA1Op18oaQYLsmQXhCpjFDoTT+erg3n2upRre57+UhK95Wu50htTVYM2gcz
 GMvooasVRw9n7j4Ug86oAUWvhmfHcToImlTBJVMK38H3F+nJe1xQrA5hPzuqI/DP3lmwmC
 BVZjbxEW/DSYX6NYlZS0LA5jifhAhUU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-qEUIdr5wMxCetO_K12oy4A-1; Fri, 08 Jan 2021 05:04:01 -0500
X-MC-Unique: qEUIdr5wMxCetO_K12oy4A-1
Received: by mail-wr1-f70.google.com with SMTP id i4so3921212wrm.21
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 02:04:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:subject:to:cc:references:from:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=11l3mj1UE5jX79PBsPyiLxVECs3/fF4MoveQY9G6pbQ=;
 b=t4vEKMA6XZ8ccl/4hCHHg88jh9otIYBYsB8Dlsoh1grFFyjiEdo5ChCuvj+1EhXNS3
 BFrdbJemTjGuXnAlQ7rYGRTneBKljwH7lb2lQduOzS306OaZO2U6HwdFH7SAAag+gXK7
 eeiLLIv13/Mwkma69DrOrOLT78JoIZ1pTnjyR/CsG1WTcPZ/8P6nTvc0HiwxtA1quGtW
 vdgueBKRpTvL6sCupj5+K6kfckY97fKTmeHkh36xkp1Kgf8KoBfPiksp495Rr5w2pm40
 qjWAH/vREDur4euOlZY/9Ju7T8TsAarCnrzN4sxoqndEVBpQlOTtdm7CGvDMzSswMG18
 RjEg==
X-Gm-Message-State: AOAM533CDC9WWX0ulnhq/qog9qDCE5OZvi3KPfpIsPuY50BtHJa+B7Lw
 UJ4e6V40N9oVOm+WJTMgzeCb+YYWw60Gg3DwHOH1OqUqCyYMDDyydkob7WSkOKKgWK9ilN7HlQg
 SiDuNaQcUpYG78GcJutYfuTce
X-Received: by 2002:a1c:2091:: with SMTP id g139mr2373449wmg.133.1610100239939; 
 Fri, 08 Jan 2021 02:03:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyFyMLPpPYKbyxpZXOaQ2QHZKNsKsCm/85IAHueIGD5l8QsZqKB6OB7QmV+330rv7+imjV54A==
X-Received: by 2002:a1c:2091:: with SMTP id g139mr2373427wmg.133.1610100239715; 
 Fri, 08 Jan 2021 02:03:59 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id x7sm10927331wmi.11.2021.01.08.02.03.57
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 08 Jan 2021 02:03:58 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.11, take #1
To: Marc Zyngier <maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
 <35b38baf-bd75-9054-76f8-15e642e05f55@redhat.com>
 <47864d22df766d6028f437a20aa4668a@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b75a791a-6727-1b55-ea96-d7860b4ade80@redhat.com>
Date: Fri, 8 Jan 2021 11:03:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <47864d22df766d6028f437a20aa4668a@kernel.org>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: kernel-team@android.com, kvm@vger.kernel.org, Qian Cai <qcai@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

T24gMDgvMDEvMjEgMDk6MjIsIE1hcmMgWnluZ2llciB3cm90ZToKPj4KPj4+IMKgwqAgZ2l0Oi8v
Z2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L2t2bWFybS9rdm1hcm0uZ2l0
IAo+Pj4gdGFncy9rdm1hcm0tZml4ZXMtNS4xMS0xCj4+Cj4+IExvb2tzIGxpa2UgdGhlcmUgYXJl
IGlzc3VlcyB3aXRoIHRoZSB1cHN0cmVhbSBjaGFuZ2VzIGJyb3VnaHQgaW4gYnkKPj4gdGhpcyBw
dWxsIHJlcXVlc3QuwqAgVW5sZXNzIG15IGJpc2VjdGlvbiBpcyBxdWljayB0b21vcnJvdyBpdCBt
YXkgbm90Cj4+IG1ha2UgaXQgaW50byA1LjExLXJjMy7CoCBJbiBhbnkgY2FzZSwgaXQncyBpbiBt
eSBoYW5kcy4KPiAKPiBJJ20gbm90IHN1cmUgd2hhdCB5b3UgbWVhbiBieSAidXBzdHJlYW0gY2hh
bmdlcyIsIGFzIHRoZXJlIGlzIG5vCj4gYWRkaXRpb25hbCBjaGFuZ2VzIG9uIHRvcCBvZiB3aGF0
IGlzIGRlc2NyaWJlIGluIHRoaXMgcHVsbCByZXF1ZXN0LAo+IHdoaWNoIGlzIGRpcmVjdGx5IGJh
c2VkIG9uIHRoZSB0YWfCoCB5b3UgcHVsbGVkIGZvciB0aGUgbWVyZ2Ugd2luZG93Lgo+IAo+IElm
IHRoZXJlIGlzIGFuIGlzc3VlIHdpdGggYW55IG9mIHRoZXNlIDE4IHBhdGNoZXMgdGhlbXNlbHZl
cywgcGxlYXNlCj4gc2hvdXQgYXMgc29vbiBhcyB5b3UgY2FuLgoKWW91J3JlIHJpZ2h0LCBpdCdz
IG5vdCByZWxhdGVkIHRvIHRoaXMgcHVsbCByZXF1ZXN0IGJ1dCBqdXN0IHRvIExpbnVzJ3MgCnRy
ZWUuICBJdCB3YXMgdG9vIGxhdGUgeWVzdGVyZGF5LCBhbmQgbm93IGl0J3MgYWxsIHNldCBmb3Ig
c2VuZGluZyBpdCBvdXQuCgpQYW9sbwoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1i
aWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3Zt
YXJtCg==
