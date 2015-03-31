From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v2 3/4] target-arm: kvm - support for single step
Date: Tue, 31 Mar 2015 16:40:45 +0100
Message-ID: <1427816446-31586-4-git-send-email-alex.bennee@linaro.org>
References: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A5424A77F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2015 11:33:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CRR74BI1agTQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Mar 2015 11:33:48 -0400 (EDT)
Received: from socrates.bennee.com
 (static.88-198-71-155.clients.your-server.de [88.198.71.155])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D9564A782
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Mar 2015 11:33:48 -0400 (EDT)
In-Reply-To: <1427816446-31586-1-git-send-email-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: qemu-devel@nongnu.org, peter.maydell@linaro.org, christoffer.dall@linaro.org, zhichao.huang@linaro.org
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBhZGRzIHN1cHBvcnQgZm9yIHNpbmdsZS1zdGVwLiBUaGVyZSBpc24ndCBtdWNoIHRvIGRv
IG9uIHRoZSBRRU1VCnNpZGUgYXMgYWZ0ZXIgd2Ugc2V0LXVwIHRoZSByZXF1ZXN0IGZvciBzaW5n
bGUgc3RlcCB2aWEgdGhlIGRlYnVnIGlvY3RsCml0IGlzIGFsbCBoYW5kbGVkIHdpdGhpbiB0aGUg
a2VybmVsLgoKU2lnbmVkLW9mZi1ieTogQWxleCBCZW5uw6llIDxhbGV4LmJlbm5lZUBsaW5hcm8u
b3JnPgoKLS0tCnYyCiAgLSBjb252ZXJ0IHRvIHVzaW5nIEhTUl9FQwoKZGlmZiAtLWdpdCBhL3Rh
cmdldC1hcm0va3ZtLmMgYi90YXJnZXQtYXJtL2t2bS5jCmluZGV4IDI5MGMxZmUuLmFlMGY4YjIg
MTAwNjQ0Ci0tLSBhL3RhcmdldC1hcm0va3ZtLmMKKysrIGIvdGFyZ2V0LWFybS9rdm0uYwpAQCAt
NDc1LDYgKzQ3NSw3IEBAIHZvaWQga3ZtX2FyY2hfcG9zdF9ydW4oQ1BVU3RhdGUgKmNzLCBzdHJ1
Y3Qga3ZtX3J1biAqcnVuKQogKi8KIAogI2RlZmluZSBIU1JfRUNfU0hJRlQgICAgICAgICAgICAy
NgorI2RlZmluZSBIU1JfRUNfU09GVF9TVEVQICAgICAgICAweDMyCiAjZGVmaW5lIEhTUl9FQ19T
V19CS1BUICAgICAgICAgIDB4M2MKIAogc3RhdGljIGludCBrdm1faGFuZGxlX2RlYnVnKENQVVN0
YXRlICpjcywgc3RydWN0IGt2bV9ydW4gKnJ1bikKQEAgLTQ4Myw2ICs0ODQsMTMgQEAgc3RhdGlj
IGludCBrdm1faGFuZGxlX2RlYnVnKENQVVN0YXRlICpjcywgc3RydWN0IGt2bV9ydW4gKnJ1bikK
ICAgICBpbnQgaHNyX2VjID0gYXJjaF9pbmZvLT5oc3IgPj4gSFNSX0VDX1NISUZUOwogCiAgICAg
c3dpdGNoIChoc3JfZWMpIHsKKyAgICBjYXNlIEhTUl9FQ19TT0ZUX1NURVA6CisgICAgICAgIGlm
IChjcy0+c2luZ2xlc3RlcF9lbmFibGVkKSB7CisgICAgICAgICAgICByZXR1cm4gdHJ1ZTsKKyAg
ICAgICAgfSBlbHNlIHsKKyAgICAgICAgICAgIGVycm9yX3JlcG9ydCgiQ2FtZSBvdXQgb2YgU0lO
R0xFIFNURVAgd2hlbiBub3QgZW5hYmxlZCIpOworICAgICAgICB9CisgICAgICAgIGJyZWFrOwog
ICAgIGNhc2UgSFNSX0VDX1NXX0JLUFQ6CiAgICAgICAgIGlmIChrdm1fZmluZF9zd19icmVha3Bv
aW50KGNzLCBhcmNoX2luZm8tPnBjKSkgewogICAgICAgICAgICAgcmV0dXJuIHRydWU7CkBAIC01
NDIsNiArNTUwLDkgQEAgaW50IGt2bV9hcmNoX29uX3NpZ2J1cyhpbnQgY29kZSwgdm9pZCAqYWRk
cikKIAogdm9pZCBrdm1fYXJjaF91cGRhdGVfZ3Vlc3RfZGVidWcoQ1BVU3RhdGUgKmNzLCBzdHJ1
Y3Qga3ZtX2d1ZXN0X2RlYnVnICpkYmcpCiB7CisgICAgaWYgKGNzLT5zaW5nbGVzdGVwX2VuYWJs
ZWQpIHsKKyAgICAgICAgZGJnLT5jb250cm9sIHw9IEtWTV9HVUVTVERCR19FTkFCTEUgfCBLVk1f
R1VFU1REQkdfU0lOR0xFU1RFUDsKKyAgICB9CiAgICAgaWYgKGt2bV9zd19icmVha3BvaW50c19h
Y3RpdmUoY3MpKSB7CiAgICAgICAgIGRiZy0+Y29udHJvbCB8PSBLVk1fR1VFU1REQkdfRU5BQkxF
IHwgS1ZNX0dVRVNUREJHX1VTRV9TV19CUDsKICAgICB9Ci0tIAoyLjMuNAoKX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18Ka3ZtYXJtIG1haWxpbmcgbGlzdApr
dm1hcm1AbGlzdHMuY3MuY29sdW1iaWEuZWR1Cmh0dHBzOi8vbGlzdHMuY3MuY29sdW1iaWEuZWR1
L21haWxtYW4vbGlzdGluZm8va3ZtYXJtCg==
