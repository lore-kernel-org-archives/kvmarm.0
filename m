From: Riku Voipio <riku.voipio@linaro.org>
Subject: UEFI on KVM fails to start on juno on cortex-a57 cluster
Date: Wed, 25 Mar 2015 08:59:45 +0200
Message-ID: <CAAqcGHmFGO8DaU-G0A6geOzDZDmWAtjHN6wOmJQVBjyi6_WVzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE135499C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 02:52:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uKarKGjtmqKC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Mar 2015 02:52:50 -0400 (EDT)
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 263AD49928
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Mar 2015 02:52:49 -0400 (EDT)
Received: by wgra20 with SMTP id a20so16070307wgr.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Mar 2015 23:59:46 -0700 (PDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Virtualization Team <virtualization@linaro.org>, linaro-uefi@lists.linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

SGksCgpJdCBhcHBlYXJzIG9uIGp1bm8sIEkgY2FuIHN0YXJ0IGt2bSB3aXRoIFVFRkkgb25seSBv
biBjb3J0ZXgtYTUzIGNvcmVzOgoKCnRhc2tzZXQgLWMgMCBxZW11LXN5c3RlbS1hYXJjaDY0IC1t
IDEwMjQgLWNwdSBob3N0IC1NIHZpcnQgLWJpb3MKUUVNVV9FRkkuZmQgLWVuYWJsZS1rdm0gLW5v
Z3JhcGhpYwotPiB3b3JrczoKVUVGSSBJbnRlcmFjdGl2ZSBTaGVsbCB2Mi4wCnRhc2tzZXQgLWMg
MSBxZW11LXN5c3RlbS1hYXJjaDY0IC1tIDEwMjQgLWNwdSBob3N0IC1NIHZpcnQgLWJpb3MKUUVN
VV9FRkkuZmQgLWVuYWJsZS1rdm0gLW5vZ3JhcGhpYwotPiBoYW5ncyBhdCBjcHUgc3Bpbm5pbmcg
MTAwJQouLi4KClFlbXUgYW5kIGtlcm5lbCBhcmUgbGF0ZXN0IG1haW5saW5lLCBrdm0gZnJvbSBs
YXN0IG1vbnRocyDEuWluYXJvCnJlbGVhc2UuIEFjY29yZGluZyB0byBjcHVpbmZvIGNvcmVzIDAg
YW5kIDMtNSBhcmUgYTUzIGFuZCAxLTIgYXJlIGE1Ny4KRGV0YWlsczoKCiMgd2dldCBodHRwOi8v
cmVsZWFzZXMubGluYXJvLm9yZy8xNS4wMS9jb21wb25lbnRzL2tlcm5lbC91ZWZpLWxpbmFyby9y
ZWxlYXNlL3FlbXU2NC1pbnRlbGJkcy9RRU1VX0VGSS5mZAp1bmFtZSAtYQojIExpbnV4IGxpbmFy
by1uYW5vIDQuMC4wLXJjNS1saW5hcm8tanVubyAjMSBTTVAgUFJFRU1QVCBUdWUgTWFyIDI0CjEw
OjQ2OjUzIFVUQyAyMDE1IGFhcmNoNjQgYWFyY2g2NCBhYXJjaDY0IEdOVS9MaW51eAojIHFlbXUt
c3lzdGVtLWFhcmNoNjQgLS12ZXJzaW9uClFFTVUgZW11bGF0b3IgdmVyc2lvbiAyLjIuOTEgKERl
YmlhbiAyLjMuMH5yYzEtMTg1bGluYXJvK3V0b3BpYyksCkNvcHlyaWdodCAoYykgMjAwMy0yMDA4
IEZhYnJpY2UgQmVsbGFyZAojIGdyZXAgLUUgJyhwcm9jZXNzb3J8cGFydCknIC9wcm9jL2NwdWlu
Zm8KcHJvY2Vzc29yICAgICAgIDogMApDUFUgcGFydCAgICAgICAgOiAweGQwMwpwcm9jZXNzb3Ig
ICAgICAgOiAxCkNQVSBwYXJ0ICAgICAgICA6IDB4ZDA3CnByb2Nlc3NvciAgICAgICA6IDIKQ1BV
IHBhcnQgICAgICAgIDogMHhkMDcKcHJvY2Vzc29yICAgICAgIDogMwpDUFUgcGFydCAgICAgICAg
OiAweGQwMwpwcm9jZXNzb3IgICAgICAgOiA0CkNQVSBwYXJ0ICAgICAgICA6IDB4ZDAzCnByb2Nl
c3NvciAgICAgICA6IDUKQ1BVIHBhcnQgICAgICAgIDogMHhkMDMKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdAprdm1hcm1A
bGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1L21haWxt
YW4vbGlzdGluZm8va3ZtYXJtCg==
