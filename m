From: hiwu <hiwu@derytech.com.tw>
Subject: Re: ARM KVM guest virtual address to host virtual address Look up
Date: Fri, 15 Jan 2016 23:35:24 +0800
Message-ID: <569911BC.3090102@derytech.com.tw>
References: <911dda08e570d71c948d7f9dad3e3e04.squirrel@mail.derytech.com.tw>
 <CAFEAcA-rOAGxVrEs5q--z5BFq2YR0ExK8cmQn2PX1s+cCo27hA@mail.gmail.com>
 <q70d9pc1o02g0mosm9n96cvw.1452856464824@email.android.com>
 <CAFEAcA_cSpFSZX02PJTCvQV6uB75_SbhBkLb1_2Z3uyy+BhBxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; Format="flowed"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E00149A18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:31:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5MHMpOlW6Ch8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Jan 2016 10:31:22 -0500 (EST)
Received: from msr5.hinet.net (msr5.hinet.net [168.95.4.105])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 89DC149A11
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Jan 2016 10:31:20 -0500 (EST)
In-Reply-To: <CAFEAcA_cSpFSZX02PJTCvQV6uB75_SbhBkLb1_2Z3uyy+BhBxA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

SGkgUGV0ZXI6CgpUaGUgZ3Vlc3QncyBsb2FkL3N0b3JlIGluc3RydWN0aW9ucywgd2hpY2ggSSB3
YW50IHRvIGRlYnVnLCBkbyBub3QgY2F1c2UgCmEgZ3Vlc3QgZXhjZXB0aW9uLgpBUk0gS1ZNIG9u
bHkgcHJvdmlkZXMgdGhlIGd1ZXN0JyByMTUgcmVnaXN0ZXIgKHBjKSB2YWx1ZS4gIFRvIGdldCB0
aGUgCmd1ZXN0IGluc3RydWN0aW9uIGZvcgplbXVsYXRpbmcgaW4gaG9zdCwgInRyYW5zbGF0ZSBn
dWVzdCBWQSB0byBob3N0IFZBIiBpcyByZXF1aXJlZC4gSG93IHRvIAppbXBsZW1lbnQKInRyYW5z
bGF0ZSBndWVzdCBWQSB0byBob3N0IFZBIiBpbiBob3N0ID8KClRoYW5rIHlvdQoKLUphY2sKCgpQ
ZXRlciBNYXlkZWxsIOaWvCAyMDE2LzEvMTUg5LiL5Y2IIDA4OjE3IOWvq+mBkzoKPiBPbiAxNSBK
YW51YXJ5IDIwMTYgYXQgMTE6MTQsIGhpd3UgPGhpd3VAZGVyeXRlY2guY29tLnR3PiB3cm90ZToK
Pj4gSSB3YW50IHRvIHRyYXAgc29tZSBsZHIsc3RyIGluc3RydWN0aW9uIGluIGd1ZXN0IFZNIGZv
ciBkZWJ1Zy4gVGhlcmVmb3JlLCBJCj4+IGhhdmUgdG8gZW11bGF0ZSBndWVzdCBsZHIsc3RyIGlu
IGhvc3QuIFdpdGhvdXQgZ3Vlc3QgVkEgdG8gaG9zdCBWQSwgSSBjYW5ub3QKPj4gZW11bGF0ZSBs
ZHIsc3RyIGluc3RydWN0aW9uIGluIGhvc3QuCj4gVGhhdCBzb3VuZHMgbGlrZSB5b3Ugd2FudCAi
bG9hZC9zdG9yZSB2YWx1ZSBmcm9tIGd1ZXN0IFZBIiwgbm90ICJ0cmFuc2xhdGUKPiBndWVzdCBW
QSB0byBob3N0IFZBIi4gVHJ5IGNwdV9sZGxfZGF0YSBhbmQgZnJpZW5kcyAodGhvdWdoIG5vdGUg
dGhhdAo+IGlmIHlvdSB1c2UgdGhlbSB0byBhY2Nlc3MgYW4gaW52YWxpZCBhZGRyZXNzIHRoZXkn
bGwgY2F1c2UgYSBndWVzdAo+IGV4Y2VwdGlvbikuCj4KPiB0aGFua3MKPiAtLSBQTU0KCgpfX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1hcm0gbWFpbGlu
ZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0cy5jcy5jb2x1
bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
