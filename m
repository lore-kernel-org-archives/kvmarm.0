From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 05/30] arm64: efi: Add missing Kconfig dependency on
 KERNEL_MODE_NEON
Date: Tue, 31 Oct 2017 15:50:57 +0000
Message-ID: <1509465082-30427-6-git-send-email-Dave.Martin@arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9026A49D50
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 11:50:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id giR8dtXjM5k2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Oct 2017 11:50:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A5349D61
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Oct 2017 11:50:05 -0400 (EDT)
In-Reply-To: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VGhlIEVGSSBydW50aW1lIHNlcnZpY2VzIEFCSSBwZXJtaXRzIGNhbGxzIHRvIEVGSSB0byBjbG9i
YmVyCmNlcnRhaW4gRlBTSU1EL05FT04gcmVnaXN0ZXJzLCBhcyBwZXIgdGhlIEFBcmNoNjQgcHJv
Y2VkdXJlIGNhbGwKc3RhbmRhcmQuCgpTYXZpbmcvcmVzdG9yaW5nIHRoZSBjbG9iYmVyZWQgcmVn
aXN0ZXJzIGFyb3VuZCBzdWNoIGNhbGxzIG5lZWRzCktFUk5FTF9NT0RFX05FT04sIGJ1dCB0aGUg
ZGVwZW5kZW5jeSBpcyBtaXNzaW5nIGZyb20gS2NvbmZpZy4KClRoaXMgcGF0Y2ggYWRkcyB0aGUg
bWlzc2luZyBkZXBlbmRlbmN5LgoKVGhpcyB3aWxsIGFpZCBiaXNlY3Rpb24gb2YgdGhlIHBhdGNo
ZXMgaW1wbGVtZW50aW5nIHN1cHBvcnQgZm9yIHRoZQpBUk0gU2NhbGFibGUgVmVjdG9yIEV4dGVu
c2lvbiAoU1ZFKS4KClNpZ25lZC1vZmYtYnk6IERhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0u
Y29tPgpSZXZpZXdlZC1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8ub3JnPgpB
Y2tlZC1ieTogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT4KQ2M6IEFy
ZCBCaWVzaGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPgotLS0KIGFyY2gvYXJtNjQv
S2NvbmZpZyB8IDEgKwogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspCgpkaWZmIC0tZ2l0
IGEvYXJjaC9hcm02NC9LY29uZmlnIGIvYXJjaC9hcm02NC9LY29uZmlnCmluZGV4IDA1YWE1OTIu
LjVjZmI3OWQgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQvS2NvbmZpZworKysgYi9hcmNoL2FybTY0
L0tjb25maWcKQEAgLTEwNjQsNiArMTA2NCw3IEBAIGNvbmZpZyBFRklfU1RVQgogY29uZmlnIEVG
SQogCWJvb2wgIlVFRkkgcnVudGltZSBzdXBwb3J0IgogCWRlcGVuZHMgb24gT0YgJiYgIUNQVV9C
SUdfRU5ESUFOCisJZGVwZW5kcyBvbiBLRVJORUxfTU9ERV9ORU9OCiAJc2VsZWN0IExJQkZEVAog
CXNlbGVjdCBVQ1MyX1NUUklORwogCXNlbGVjdCBFRklfUEFSQU1TX0ZST01fRkRUCi0tIAoyLjEu
NAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJt
IG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMu
Y3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
