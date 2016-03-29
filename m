From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v4 9/9] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Tue, 29 Mar 2016 16:39:13 +0200
Message-ID: <56FA9391.1040007@linaro.org>
References: <1458842023-31853-1-git-send-email-julien.grall@arm.com>
 <1458842023-31853-10-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDBED40FA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2016 10:38:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KmNW2Lhz3v2D for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2016 10:38:16 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A4B1640F9B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2016 10:38:16 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id r72so59927915wmg.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2016 07:39:16 -0700 (PDT)
In-Reply-To: <1458842023-31853-10-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Julien Grall <julien.grall@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

T24gMDMvMjQvMjAxNiAwNjo1MyBQTSwgSnVsaWVuIEdyYWxsIHdyb3RlOgo+IFRoZSBvbmx5IGNh
bGwgb2YgYXJjaF90aW1lcl9nZXRfdGltZWNvdW50ZXIgKGluIEtWTSkgaGFzIGJlZW4gcmVtb3Zl
ZC4KPgo+IFNpZ25lZC1vZmYtYnk6IEp1bGllbiBHcmFsbCA8anVsaWVuLmdyYWxsQGFybS5jb20+
Cj4gQWNrZWQtYnk6IENocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9y
Zz4KCkhpIEp1bGllbiwKCmRvIHlvdSB3YW50IG1lIHRvIHRha2UgdGhpcyBwYXRjaCB0aHJvdWdo
IG15IHRyZWUgPwoKICAgLS0gRGFuaWVsCgoKLS0gCiAgPGh0dHA6Ly93d3cubGluYXJvLm9yZy8+
IExpbmFyby5vcmcg4pSCIE9wZW4gc291cmNlIHNvZnR3YXJlIGZvciBBUk0gU29DcwoKRm9sbG93
IExpbmFybzogIDxodHRwOi8vd3d3LmZhY2Vib29rLmNvbS9wYWdlcy9MaW5hcm8+IEZhY2Vib29r
IHwKPGh0dHA6Ly90d2l0dGVyLmNvbS8jIS9saW5hcm9vcmc+IFR3aXR0ZXIgfAo8aHR0cDovL3d3
dy5saW5hcm8ub3JnL2xpbmFyby1ibG9nLz4gQmxvZwoKX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1AbGlzdHMu
Y3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxtYW4vbGlz
dGluZm8va3ZtYXJtCg==
