From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH 03/27] arm64: efi: Add missing Kconfig dependency on
 KERNEL_MODE_NEON
Date: Fri, 18 Aug 2017 13:02:36 +0100
Message-ID: <87o9rdhyn7.fsf@linaro.org>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
 <1502280338-23002-4-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D37D49C8F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 08:00:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iWVPhIMjOFNe for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Aug 2017 08:00:50 -0400 (EDT)
Received: from mail-wr0-f176.google.com (mail-wr0-f176.google.com
 [209.85.128.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6CA8E49C75
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 08:00:50 -0400 (EDT)
Received: by mail-wr0-f176.google.com with SMTP id y96so65831775wrc.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Aug 2017 05:02:39 -0700 (PDT)
In-reply-to: <1502280338-23002-4-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-arch@vger.kernel.org, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IFRoZSBFRkkgcnVu
dGltZSBzZXJ2aWNlcyBBQkkgcGVybWl0cyBjYWxscyB0byBFRkkgdG8gY2xvYmJlcgo+IGNlcnRh
aW4gRlBTSU1EL05FT04gcmVnaXN0ZXJzLCBhcyBwZXIgdGhlIEFBcmNoNjQgcHJvY2VkdXJlIGNh
bGwKPiBzdGFuZGFyZC4KPgo+IFNhdmluZy9yZXN0b3JpbmcgdGhlIGNsb2JiZXJlZCByZWdpc3Rl
cnMgYXJvdW5kIHN1Y2ggY2FsbHMgbmVlZHMKPiBLRVJORUxfTU9ERV9ORU9OLCBidXQgdGhlIGRl
cGVuZGVuY3kgaXMgbWlzc2luZyBmcm9tIEtjb25maWcuCj4KPiBUaGlzIHBhdGNoIGFkZHMgdGhl
IG1pc3NpbmcgZGVwZW5kZW5jeS4KPgo+IFRoaXMgd2lsbCBhaWQgYmlzZWN0aW9uIG9mIHRoZSBw
YXRjaGVzIGltcGxlbWVudGluZyBzdXBwb3J0IGZvciB0aGUKPiBBUk0gU2NhbGFibGUgVmVjdG9y
IEV4dGVuc2lvbiAoU1ZFKS4KPgo+IFNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1h
cnRpbkBhcm0uY29tPgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGlu
YXJvLm9yZz4KCj4gLS0tCj4gIGFyY2gvYXJtNjQvS2NvbmZpZyB8IDEgKwo+ICAxIGZpbGUgY2hh
bmdlZCwgMSBpbnNlcnRpb24oKykKPgo+IGRpZmYgLS1naXQgYS9hcmNoL2FybTY0L0tjb25maWcg
Yi9hcmNoL2FybTY0L0tjb25maWcKPiBpbmRleCBkZmQ5MDg2Li5mZGMzMDJlIDEwMDY0NAo+IC0t
LSBhL2FyY2gvYXJtNjQvS2NvbmZpZwo+ICsrKyBiL2FyY2gvYXJtNjQvS2NvbmZpZwo+IEBAIC0x
MDUwLDYgKzEwNTAsNyBAQCBjb25maWcgRUZJX1NUVUIKPiAgY29uZmlnIEVGSQo+ICAJYm9vbCAi
VUVGSSBydW50aW1lIHN1cHBvcnQiCj4gIAlkZXBlbmRzIG9uIE9GICYmICFDUFVfQklHX0VORElB
Tgo+ICsJZGVwZW5kcyBvbiBLRVJORUxfTU9ERV9ORU9OCj4gIAlzZWxlY3QgTElCRkRUCj4gIAlz
ZWxlY3QgVUNTMl9TVFJJTkcKPiAgCXNlbGVjdCBFRklfUEFSQU1TX0ZST01fRkRUCgoKLS0KQWxl
eCBCZW5uw6llCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
Cmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJtQGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczov
L2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWlsbWFuL2xpc3RpbmZvL2t2bWFybQo=
