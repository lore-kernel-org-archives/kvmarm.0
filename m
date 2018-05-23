From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v10 01/18] arm64: fpsimd: Fix TIF_FOREIGN_FPSTATE after
 invalidating cpu regs
Date: Wed, 23 May 2018 14:44:09 +0100
Message-ID: <87r2m2trkm.fsf@linaro.org>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
 <1527005119-6842-2-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-reply-to: <1527005119-6842-2-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

CkRhdmUgTWFydGluIDxEYXZlLk1hcnRpbkBhcm0uY29tPiB3cml0ZXM6Cgo+IGZwc2ltZF9sYXN0
X3N0YXRlLnN0IGlzIHNldCB0byBOVUxMIGFzIGEgd2F5IG9mIGluZGljYXRpbmcgdGhhdAo+IGN1
cnJlbnQncyBGUFNJTUQgcmVnaXN0ZXJzIGFyZSBubyBsb25nZXIgbG9hZGVkIGluIHRoZSBjcHUu
ICBJbgo+IHBhcnRpY3VsYXIsIHRoaXMgaXMgZG9uZSB3aGVuIHRoZSBrZXJuZWwgdGVtcG9yYXJp
bHkgdXNlcyBvcgo+IGNsb2JiZXJzIHRoZSBGUFNJTUQgcmVnaXN0ZXJzIGZvciBpdHMgb3duIHB1
cnBvc2VzLCBhcyBpbiBDUFUgUE0gb3IKPiBrZXJuZWwtbW9kZSBORU9OLCByZXN1bHRpbmcgaW4g
dGhlbSBiZWluZyBwb3B1bGF0ZWQgd2l0aCBnYXJiYWdlCj4gZGF0YSBub3QgYmVsb25naW5nIHRv
IGEgdGFzay4KPHNuaXA+Cj4KPiBTaWduZWQtb2ZmLWJ5OiBEYXZlIE1hcnRpbiA8RGF2ZS5NYXJ0
aW5AYXJtLmNvbT4KPiBDYzogQ2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNv
bT4KPiBDYzogV2lsbCBEZWFjb24gPHdpbGwuZGVhY29uQGFybS5jb20+Cj4gQ2M6IEFyZCBCaWVz
aGV1dmVsIDxhcmQuYmllc2hldXZlbEBsaW5hcm8ub3JnPgoKUmV2aWV3ZWQtYnk6IEFsZXggQmVu
bsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KCi0tCkFsZXggQmVubsOpZQoKX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KbGludXgtYXJtLWtlcm5lbCBt
YWlsaW5nIGxpc3QKbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnCmh0dHA6Ly9s
aXN0cy5pbmZyYWRlYWQub3JnL21haWxtYW4vbGlzdGluZm8vbGludXgtYXJtLWtlcm5lbAo=
