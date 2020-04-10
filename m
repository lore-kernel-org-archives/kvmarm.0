Return-Path: <SRS0=x7ye=53=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C945C2BBC7
	for <kvmarm@archiver.kernel.org>; Sat, 11 Apr 2020 09:20:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21D1320857
	for <kvmarm@archiver.kernel.org>; Sat, 11 Apr 2020 09:20:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZmtX0gYp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21D1320857
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C0D644B224;
	Sat, 11 Apr 2020 05:20:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id acmlD21JJOEw; Sat, 11 Apr 2020 05:20:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B701A4B1D5;
	Sat, 11 Apr 2020 05:20:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82A024B1B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 16:15:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zxUTcE1qGZp2 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 16:15:32 -0400 (EDT)
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com
 [209.85.215.182])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 975A64B0EA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 16:15:32 -0400 (EDT)
Received: by mail-pg1-f182.google.com with SMTP id x26so229500pgc.10
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 13:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc:content-transfer-encoding;
 bh=f86muAw523OkMjYVGNBFovEm8ZGJUiBw+jgMVnhWcLU=;
 b=ZmtX0gYpXUxLadTK5ZaoZ8oFL8gDIFXNh8zscyM0r63jYevMqmK9ixQsH+ghklSqTH
 6XvhElypZck2XS58SazFsyxW5rqE4K/YAMHeJis/lIjRW4EGo5TDRiJ5I1HmQR+F65VH
 2xPK5hWh0VcRmXLiTxkuDEHk1nJTnqeInorLkCRTULntcPmhJcgoNEvAgZhwgpq33vkk
 hhX3DNPpGpX9VYA7OTvZNQ5BF73BMvl/6TyQARpnXZGdY0odYWcnG/w37pLOFuyx6z/m
 H0h/5hX4j1woSslXpI1d9ZYbqOFML50nZhrkBhqn+X2HLSuKIW50e3y+qB2lYhDcIw3o
 Y84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc:content-transfer-encoding;
 bh=f86muAw523OkMjYVGNBFovEm8ZGJUiBw+jgMVnhWcLU=;
 b=dAoimfA9pXZaqWwDxjkGV+ITnVuxckqb4Gi5lz6ktYAbv9OalQ1Sizj7ijrhca2Tag
 kS4/lOKngTXc7/kUkFIaFZe0Mk5nkrFw2hqVD53wieGWezJbL1t9xT9B5ACScJibAu+x
 N+ZUhaRlZXO9715/Yk0LFpKeBUreSljjTa9b2/TrnKKEtKfSdkeNrijqMTavHWqYQc23
 /XHfG4eXaM9hS072itcPwvnrIk/aBpqGSp7S62Gwj2LGmeOtqQbI4Pq+gPrpO5Bp3VUQ
 8L/pllywjINBWr9BgPd8CqMfgat5vssnk/zn2gsXwnTKJIrRcUw0uQl5r9lAkqwWc4XG
 giTg==
X-Gm-Message-State: AGi0PuZofSgNJWox99LC5ob32GcSt+8nJgLUlpWDifCUxE22KhXcTnvL
 0WlcyCpQBrE/TYtNWbGi6muv889RD12UmS6gsec=
X-Google-Smtp-Source: APiQypKWaC1TdYHchEl8FbsLPt1cgpKj+D5CVgAogHXMqDZKWBUHBcSDz+0rduEyiWoCFleHipDpDU9DXL0lsgdfAJw=
X-Received: by 2002:a63:ae04:: with SMTP id q4mr5900955pgf.373.1586549731699; 
 Fri, 10 Apr 2020 13:15:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAEX+82KTJecx_aSHAPN9ZkS_YDiDfyEM9b6ji4wabmSZ6O516Q@mail.gmail.com>
 <548a7864dce9aaf132f90fbb67bd3f52@kernel.org>
In-Reply-To: <548a7864dce9aaf132f90fbb67bd3f52@kernel.org>
From: Javier Romero <xavinux@gmail.com>
Date: Fri, 10 Apr 2020 17:15:20 -0300
Message-ID: <CAEX+82LpZRVb2nnxyYBxgo3N6ZcwX_9dTU1RnZ_aPW7PRuB8vA@mail.gmail.com>
Subject: Re: Contribution to KVM.
To: Marc Zyngier <maz@kernel.org>
X-Mailman-Approved-At: Sat, 11 Apr 2020 05:20:07 -0400
Cc: kvmarm@lists.cs.columbia.edu, kvm <kvm@vger.kernel.org>
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

SGkgTWFyYywKClRoYW5rIHlvdSB2ZXJ5IG11Y2ggZm9yIHlvdXIgYW5zd2VyLgoKSGF2ZSBkZWNp
ZGVkIHRvIHN0YXJ0IGNvbnRyaWJ1dGluZyB3aXRoIHRlc3Rpbmcgb24gSW50ZWwgcGxhdGZvcm0s
CmhhdmUgYSBQaXhlbGJvb2sgd2l0aCBhIENvcmUgaTcgYW5kIDE2IEdCIG9mIFJBTSBhbmQgd2ls
bCB1c2UgQXZvY2Fkbwp0byBoYXZlIGEgbG9jYWwgYXV0b21hdGVkIHRlc3Qtc3VpdGUgZW52aXJv
bm1lbnQuCgpSZWdhcmRzLAoKCkphdmllciBSb21lcm8KCkVsIHZpZS4sIDEwIGFici4gMjAyMCBh
IGxhcyA0OjQ5LCBNYXJjIFp5bmdpZXIgKDxtYXpAa2VybmVsLm9yZz4pIGVzY3JpYmnDszoKPgo+
IEhpIEphdmllciwKPgo+IE9uIDIwMjAtMDQtMDkgMjI6MjksIEphdmllciBSb21lcm8gd3JvdGU6
Cj4gPiBIZWxsbywKPiA+Cj4gPiAgTXkgbmFtZSBpcyBKYXZpZXIsIGxpdmUgaW4gQXJnZW50aW5h
IGFuZCB3b3JrIGFzIGEgY2xvdWQgZW5naW5lZXIuCj4gPgo+ID4gSGF2ZSBiZWVuIHdvcmtpbmcg
d2l0aCBMaW51eCBzZXJ2ZXJzIGZvciB0aGUgYXN0IDEwIHllYXJzIGluIGFuCj4gPiBJbnRlcm5l
dCBTZXJ2aWNlIFByb3ZpZGVyIGFuZCBJJ20gaW50ZXJlc3RlZCBpbiBjb250cmlidXRpbmcgdG8g
S1ZNCj4gPiBtYXliZSB3aXRoIHRlc3RpbmcgYXMgYSBzdGFydCBwb2ludC4KPiA+Cj4gPiBJZiBp
dCBjYW4gYmUgdXNlZnVsIHRvIHRlc3QgS1ZNIG9uIEFSTSwgSSBoYXZlIGEgUmFzcGJlcnJ5IFBJ
IDMgYXQKPiA+IGRpc3Bvc2FsLgo+Cj4gVGVzdGluZyBpcyBncmVhdCAoYWx0aG91Z2ggdGhlIFJQ
aS0zIGlzbid0IHRoZSBtb3N0IGludGVyZXN0aW5nIHBsYXRmb3JtCj4gZHVlCj4gdG8gaXRzIG1h
bnkgaGFyZHdhcmUgbGltaXRhdGlvbnMpLiBJZiB5b3UgYXJlIGZhbWlsaWFyIHdpdGggdGhlIEFS
TQo+IGFyY2hpdGVjdHVyZSwKPiBoZWxwaW5nIHdpdGggcGF0Y2ggcmV2aWV3IGlzIGFsc28gbXVj
aCBhcHByZWNpYXRlZC4KPgo+IFRoYW5rcywKPgo+ICAgICAgICAgIE0uCj4gLS0KPiBKYXp6IGlz
IG5vdCBkZWFkLiBJdCBqdXN0IHNtZWxscyBmdW5ueS4uLgpfX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0
cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9s
aXN0aW5mby9rdm1hcm0K
