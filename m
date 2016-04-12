From: Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v6 10/10] clocksource: arm_arch_timer: Remove
 arch_timer_get_timecounter
Date: Tue, 12 Apr 2016 14:49:40 +0200
Message-ID: <570CEEE4.6090503@linaro.org>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
 <1460388780-914-11-git-send-email-julien.grall@arm.com>
 <20160412054447.GC16636@linaro.org> <20160412121511.GB3039@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4F0944011D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:48:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aFNbKPsUolNV for <kvmarm@lists.cs.columbia.edu>;
 Tue, 12 Apr 2016 08:48:05 -0400 (EDT)
Received: from mail-wm0-f48.google.com (mail-wm0-f48.google.com [74.125.82.48])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 69B70400E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 08:48:05 -0400 (EDT)
Received: by mail-wm0-f48.google.com with SMTP id f198so186185988wme.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 12 Apr 2016 05:49:43 -0700 (PDT)
In-Reply-To: <20160412121511.GB3039@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

T24gMDQvMTIvMjAxNiAwMjoxNSBQTSwgQ2hyaXN0b2ZmZXIgRGFsbCB3cm90ZToKPiBIaSBEYW5p
ZWwsCj4KPiBPbiBUdWUsIEFwciAxMiwgMjAxNiBhdCAwNzo0NDo0N0FNICswMjAwLCBEYW5pZWwg
TGV6Y2FubyB3cm90ZToKPj4gT24gTW9uLCBBcHIgMTEsIDIwMTYgYXQgMDQ6MzM6MDBQTSArMDEw
MCwgSnVsaWVuIEdyYWxsIHdyb3RlOgo+Pj4gVGhlIG9ubHkgY2FsbCBvZiBhcmNoX3RpbWVyX2dl
dF90aW1lY291bnRlciAoaW4gS1ZNKSBoYXMgYmVlbiByZW1vdmVkLgo+Pj4KPj4+IFNpZ25lZC1v
ZmYtYnk6IEp1bGllbiBHcmFsbCA8anVsaWVuLmdyYWxsQGFybS5jb20+Cj4+PiBBY2tlZC1ieTog
Q2hyaXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5hcm8ub3JnPgo+Pj4KPj4+IC0t
LQo+Pj4gQ2M6IERhbmllbCBMZXpjYW5vIDxkYW5pZWwubGV6Y2Fub0BsaW5hcm8ub3JnPgo+Pj4g
Q2M6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgo+Pj4KPj4+ICAgICAgQ2hh
bmdlcyBpbiB2NDoKPj4+ICAgICAgICAgIC0gQWRkIENocmlzdG9mZmVyJ3MgYWNrZWQtYnkKPj4+
Cj4+PiAgICAgIENoYW5nZXMgaW4gdjM6Cj4+PiAgICAgICAgICAtIFBhdGNoIGFkZGVkCj4+PiAt
LS0KPj4KPj4gQWNrZWQtYnk6IERhbmllbCBMZXpjYW5vIDxkYW5pZWwubGV6Y2Fub0BsaW5hcm8u
b3JnPgo+Cj4gaGF2aW5nIGFja2VkIHRoZXNlLCBkbyB5b3Ugd2FudCB1cyB0byBqdXN0IHRha2Ug
dGhpcyBhIGNvbXBsZXRlIHNlcmllcwo+IHZpYSB0aGUga3ZtYXJtIHRyZWUgb3IgZG8geW91IHBs
YW4gb24gbWVyZ2luZyB0aGUgcGF0Y2hlcyBpbmRpdmlkdWFsbHk/CgpKdXN0IHRha2UgaXQgdmlh
IHRoZSBrdm1hcm0gdHJlZS4KCiAgIC0tIERhbmllbAoKCi0tIAogIDxodHRwOi8vd3d3LmxpbmFy
by5vcmcvPiBMaW5hcm8ub3JnIOKUgiBPcGVuIHNvdXJjZSBzb2Z0d2FyZSBmb3IgQVJNIFNvQ3MK
CkZvbGxvdyBMaW5hcm86ICA8aHR0cDovL3d3dy5mYWNlYm9vay5jb20vcGFnZXMvTGluYXJvPiBG
YWNlYm9vayB8CjxodHRwOi8vdHdpdHRlci5jb20vIyEvbGluYXJvb3JnPiBUd2l0dGVyIHwKPGh0
dHA6Ly93d3cubGluYXJvLm9yZy9saW5hcm8tYmxvZy8+IEJsb2cKCl9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCmt2bWFybSBtYWlsaW5nIGxpc3QKa3ZtYXJt
QGxpc3RzLmNzLmNvbHVtYmlhLmVkdQpodHRwczovL2xpc3RzLmNzLmNvbHVtYmlhLmVkdS9tYWls
bWFuL2xpc3RpbmZvL2t2bWFybQo=
