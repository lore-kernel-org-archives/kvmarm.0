From: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: Re: [PATCH v2] target-arm: Store SPSR_EL1 state in banked_spsr[1]
 (SPSR_svc)
Date: Wed, 18 Mar 2015 13:58:40 +0000
Message-ID: <87twxis8z3.fsf@linaro.org>
References: <1426620735-2454-1-git-send-email-peter.maydell@linaro.org>
 <20150317193816.GB23225@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD06449046
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 09:51:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id biU79aHJcOLb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 18 Mar 2015 09:51:42 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9DFC649045
 for <kvmarm@lists.cs.columbia.edu>; Wed, 18 Mar 2015 09:51:41 -0400 (EDT)
In-reply-to: <20150317193816.GB23225@cbox>
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
Cc: Greg Bellows <greg.bellows@linaro.org>, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

CkNocmlzdG9mZmVyIERhbGwgPGNocmlzdG9mZmVyLmRhbGxAbGluYXJvLm9yZz4gd3JpdGVzOgoK
PiBPbiBUdWUsIE1hciAxNywgMjAxNSBhdCAwNzozMjoxNVBNICswMDAwLCBQZXRlciBNYXlkZWxs
IHdyb3RlOgo+PiBUaGUgQUFyY2g2NCBTUFNSX0VMMSByZWdpc3RlciBpcyBhcmNoaXRlY3R1cmFs
bHkgbWFuZGF0ZWQgdG8KPj4gYmUgbWFwcGVkIHRvIHRoZSBBQXJjaDMyIFNQU1Jfc3ZjIHJlZ2lz
dGVyLiBUaGlzIG1lYW5zIGl0cwo+PiBzdGF0ZSBzaG91bGQgbGl2ZSBpbiBRRU1VJ3MgZW52LT5i
YW5rZWRfc3BzclsxXSBmaWVsZC4KPj4gQ29ycmVjdCB0aGUgdmFyaW91cyBwbGFjZXMgaW4gdGhl
IGNvZGUgdGhhdCBpbmNvcnJlY3RseQo+PiBwdXQgaXQgaW4gYmFua2VkX3Nwc3JbMF0uCj4+IAo+
PiBTaWduZWQtb2ZmLWJ5OiBQZXRlciBNYXlkZWxsIDxwZXRlci5tYXlkZWxsQGxpbmFyby5vcmc+
Cj4KPiBSZXZpZXdlZC1ieTogQ2hyaXN0b2ZmZXIgRGFsbCA8Y2hyaXN0b2ZmZXIuZGFsbEBsaW5h
cm8ub3JnPgo+Cj4KPiBBbGV4LCB3aWxsIHlvdSByZXNwaW4gdGhlIFNQU1IgcGF0Y2ggYmFzZWQg
b24gdGhpcyBvbmUgdGhlbj8gIFlvdSBjYW4KPiBjaGFuZ2UgdGhlIGF1dGhvcnNoaXAgb24gdGhl
IFNQU1IgcGF0Y2ggdG8geW91cnNlbGYgaWYgeW91IHByZWZlci4KClllYWggSSdsbCByZS1zcGlu
IHRoZSBzZXJpZXMgaG9wZWZ1bGx5IGJ5IHRoZSBlbmQgb2YgdGhpcyB3ZWVrIG9yIGVhcmx5IG5l
eHQuCgo+Cj4gVGhhbmtzLAo+IC1DaHJpc3RvZmZlcgoKLS0gCkFsZXggQmVubsOpZQpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGluZyBs
aXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1bWJp
YS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
