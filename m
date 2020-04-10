Return-Path: <SRS0=x7ye=53=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF9AC2BA2B
	for <kvmarm@archiver.kernel.org>; Sat, 11 Apr 2020 09:20:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E8A520857
	for <kvmarm@archiver.kernel.org>; Sat, 11 Apr 2020 09:20:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F+5Oqtal"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E8A520857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A7F374B222;
	Sat, 11 Apr 2020 05:20:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id d6IytvkJoHyZ; Sat, 11 Apr 2020 05:20:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 97D8C4B21E;
	Sat, 11 Apr 2020 05:20:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9CD24B18F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 15:41:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AdKDIquQ6yk1 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 15:41:54 -0400 (EDT)
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CC6B74B0E5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 15:41:54 -0400 (EDT)
Received: by mail-pg1-f195.google.com with SMTP id p8so1382177pgi.5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 12:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:subject:from:in-reply-to:date:cc
 :content-transfer-encoding:message-id:references:to;
 bh=CgnU+ujBRV0gbvV/FEvyB7C6MQ/ZUVq1NHOVW73TsKw=;
 b=F+5Oqtal202Cfks9CO4zEB6xzOim31mB0c4paOikBeD9zHAIBjMRvuwBu6yg3XOnMa
 2DwEgrm3UNc7KuqUX7eQcMNQakhF1MArVGNQvD/LR+cqWB7pdBHHc+7+MmSp87lb0TPE
 XekaT72poEU3N7K/iOUS6mjNbwyltW0sNPMl7sy+9XWPd6lRGV/kTKdLzSTPMIMgkVGT
 3x42P03IOg/vT0KUY+qR17hg0jdkKLCipPHnAUKyQw5nfGQtxsRcjUj9CUpLfeM/7w61
 qPJaFbFkN1unRWebpkmVELt0ijaY2wqVvsAjaMQ83QmqdXX3opbws5VJgd9uF8rK8ooH
 fWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
 :content-transfer-encoding:message-id:references:to;
 bh=CgnU+ujBRV0gbvV/FEvyB7C6MQ/ZUVq1NHOVW73TsKw=;
 b=HCnUzesW/WWkuY51p3ZLZV+MvndxPRahzPlHHo13Beyd7JodHwkKCSTQSnEaD2L4rZ
 UtUdrZ0i63UNpO9XVYSyplEtuHok5j2idP3Ub+7ILF9JhSa4KT59FGC3SF/DHjQzU59d
 WurySj6mY7A0urpcV66c+viisVkSxTD34uQEdQv/c8q3s1UVdoWd7/X/auRaclzTOQNo
 ZxN6e2KlJS9RRC+7ssHypJEP6x4FCDai4wdLtC+sVVTNVVbw/+wAm3vFt6CNHfLWUdvA
 oBpJgMTHMZsdvUwR7VMpFlMv7Hg0qKhCAp/LBryJu9PhcPDc2H0Nn9Got9q43RkADLKC
 hu7g==
X-Gm-Message-State: AGi0PuYEZ7Ck+8LbaJBLPVF1UsioB3mGS0rpFKL8v/LJfsHhyC6WAu6u
 ho0vNG4VjwYAhCGgRqoMyNs=
X-Google-Smtp-Source: APiQypJOBRKFJSxkKIGN2xfjPWPl/+lBs+mMibX5Q01dX/ddCq3mD+f8Cts+eOjWSrg5zkfzAd289A==
X-Received: by 2002:a62:ee10:: with SMTP id e16mr6411313pfi.247.1586547713462; 
 Fri, 10 Apr 2020 12:41:53 -0700 (PDT)
Received: from [10.0.1.60] (c-24-4-128-201.hsd1.ca.comcast.net. [24.4.128.201])
 by smtp.gmail.com with ESMTPSA id s39sm2491073pjb.10.2020.04.10.12.41.52
 (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
 Fri, 10 Apr 2020 12:41:52 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: Contribution to KVM.
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <9d46406f-c483-746b-058f-cceda22f1029@oracle.com>
Date: Fri, 10 Apr 2020 12:41:51 -0700
Message-Id: <40B0C1D8-06B9-4E12-BB7B-E7E3AFF4409E@gmail.com>
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <c86002a6-d613-c0be-a672-cca8e9c83e1c@intel.com>
 <2E118FCA-7AB1-480F-8F49-3EFD77CC2992@gmail.com>
 <9d46406f-c483-746b-058f-cceda22f1029@oracle.com>
To: Liran Alon <liran.alon@oracle.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
X-Mailman-Approved-At: Sat, 11 Apr 2020 05:20:07 -0400
Cc: like.xu@intel.com, Javier Romero <xavinux@gmail.com>,
 kvm <kvm@vger.kernel.org>, kvmarm@lists.cs.columbia.edu
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

PiBPbiBBcHIgMTAsIDIwMjAsIGF0IDM6MjAgQU0sIExpcmFuIEFsb24gPGxpcmFuLmFsb25Ab3Jh
Y2xlLmNvbT4gd3JvdGU6Cj4gCj4gCj4gT24gMTAvMDQvMjAyMCA2OjUyLCBOYWRhdiBBbWl0IHdy
b3RlOgo+PiAyLiBUcnkgdG8gcnVuIHRoZSB0ZXN0cyB3aXRoIG1vcmUgdGhhbiA0R0Igb2YgbWVt
b3J5LiBUaGUgbGFzdCB0aW1lIEkgdHJpZWQKPj4gICAgKGFjdHVhbGx5IGJ5IHJ1bm5pbmcgdGhl
IHRlc3Qgb24gYmFyZSBtZXRhbCksIHRoZSBJTklUIHRlc3QgdGhhdCBMaXJhbgo+PiAgICB3cm90
ZSBmYWlsZWQuCj4gV2Fzbid0IHRoaXMgdGVzdCBmYWlsdXJlIGZpeGVkIHdpdGgga3ZtLXVuaXQt
dGVzdCBjb21taXQgZmM0N2NjYzE5NjEyICgieDg2OiB2bXg6IFZlcmlmeSBwZW5kaW5nIExBUElD
IElOSVQgZXZlbnQgY29uc3VtZSB3aGVuIGV4aXQgb24gVk1YX0lOSVQiKT8KPiBJZiBub3QsIGNh
biB5b3UgcHJvdmlkZSB0aGUgZGV0YWlscyBvZiB0aGlzIG5ldyBmYWlsdXJlPyBBcyBJIHRob3Vn
aHQgdGhpcyBjb21taXQgYWRkcmVzcyB0aGUgcHJldmlvdXMgaXNzdWUgeW91IGhhdmUgcmVwb3J0
ZWQgd2hlbiBydW5uaW5nIHRoaXMgdGVzdAo+IG9uIGJhcmUtbWV0YWwuCgpZb3VyIHBhdGNoIHNv
bHZlZCB0aGUgcHJvYmxlbSBvZiBJTklUIGFuZCBhcHBhcmVudGx5IHlvdSBnb3QgdGhlIHJpZ2h0
CmltcGxlbWVudGF0aW9uIGluIEtWTS4KClRoZXJlIGFwcGVhcnMgdG8gYmUgYW5vdGhlciBpc3N1
ZSwgd2hpY2ggSSBzdXNwZWN0IGlzIG9ubHkgYSB0ZXN0IGlzc3VlLAp3aGVuIEkgcnVuIHRoZSB0
ZXN0cyBvbiBiYXJlLW1ldGFsIHdpdGggbW9yZSB0aGFuIDRHQiBvZiBtZW1vcnkuIElmIEkgcmVt
b3ZlClBhb2xv4oCZcyBwYXRjaCB0aGUgZW5hYmxlZCBzdXBwb3J0IGZvciBtb3JlIHRoYW4gNEdC
IG9mIFJBTSwgb3IgaWYgSSBydW4gaXQKb24gYSBWTSB3aXRoIDRHQiBvZiBSQU0gaXQgcGFzc2Vz
LiBJIGRpZCBub3QgcnVuIHRoZSB0ZXN0cyBvbiBLVk0gLSB0byBiZQpmYWlyLgoKSGVyZSBpcyB0
aGUgc3BsYXQgSSBnb3Qgb24gYSBub24tS1ZNIGh5cGVydmlzb3Igd2l0aCA4R0Igb3IgUkFNOgoK
VGVzdCBzdWl0ZTogdm14X2luaXRfc2lnbmFsX3Rlc3QKVW5oYW5kbGVkIGNwdSBleGNlcHRpb24g
MTQgI1BGIGF0IGlwIDAwMDAwMDAwMDA0MTk2OTgKUEYgYXQgMHg0MTk2OTggYWRkciAweDEwMjA2
NjAwMAplcnJvcl9jb2RlPTAwMDAgICAgICByZmxhZ3M9MDAwMTAwNDYgICAgICBjcz0wMDAwMDAw
OApyYXg9MDAwMDAwMDAwMDAwMDAwMCByY3g9MDAwMDAwMDAwMDAwMDgwYiByZHg9MDAwMDAwMDAw
MDAwMDAwMSByYng9MDAwMDAwMDEwMjA2NjAwMApyYnA9MDAwMDAwMDAwMDUzYTdiOCByc2k9MDAw
MDAwMDAwMDAwMDAwMCByZGk9MDAwMDAwMDEwMjA2NTAwMAogcjg9MDAwMDAwMDAwMDUzYTAxNiAg
cjk9MDAwMDAwMDAwMDAwMDNmOCByMTA9MDAwMDAwMDAwMDAwMDAwZCByMTE9MDAwMDAwMDAwMDAw
MDAwMApyMTI9MDAwMDAwMDEwMjA2NTAwMCByMTM9MDAwMDAwMDEwMjA2NTAwMCByMTQ9MDAwMDAw
MDAwMDAwMDAwMCByMTU9MDAwMDAwMDAwMDAwMDAwMApjcjA9MDAwMDAwMDA4MDAwMDAxMSBjcjI9
MDAwMDAwMDEwMjA2NjAwMCBjcjM9MDAwMDAwMDAwMDQyMjAwMCBjcjQ9MDAwMDAwMDAwMDAwMDAy
MApjcjg9MDAwMDAwMDAwMDAwMDAwMAoJU1RBQ0s6IEA0MTk2OTggNDA3NTM5IDQxOWY4MSA0MTll
YjEKClsgSSByYW4gaXQgYWxzbyBvbiBiYXJlIG1ldGFsLCBhbmQgZ290IElJUkMgZ290IGEgc2lt
aWxhciBzcGxhdCwgYnV0IGRpZCBub3QKc2F2ZSBpdC4gXQoKVGhlIHNwbGF0IHNob3dzIHRoZSBm
YWlsdXJlIGhhcHBlbmVkIGluIGFsbG9jX3BhZ2UoKSB3aGljaCB3YXMgY2FsbGVkIGZyb20KaW5p
dF9zaWduYWxfdGVzdF90aHJlYWQoKSBvbiB0aGUgZm9sbG93aW5nIGxpbmU6CgoJZnJlZWxpc3Qg
PSAqKHZvaWQgKiopZnJlZWxpc3Q7CgooIGFuZCBJSVJDIGZyZWVsaXN0IGlzIG5pbCApCgpJIGRp
ZCBub3QgaGF2ZSB0aW1lIHRvIGFuYWx5emUgdGhlIHByb2JsZW0gb3IgZXZlbiBydW4gaXQgb24g
S1ZNLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3Zt
YXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlz
dHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
