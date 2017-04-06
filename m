From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [RFC kvm-unit-tests PATCH 5/8] Makefile: add explicit mkdir for .o
 targets
Date: Thu,  6 Apr 2017 20:07:24 +0100
Message-ID: <20170406190727.5624-6-alex.bennee@linaro.org>
References: <20170406190727.5624-1-alex.bennee@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1B4040A6A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 15:05:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5YCO46lJDYY3 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  6 Apr 2017 15:05:24 -0400 (EDT)
Received: from mail-wr0-f169.google.com (mail-wr0-f169.google.com
 [209.85.128.169])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EBD4440CA2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  6 Apr 2017 15:05:23 -0400 (EDT)
Received: by mail-wr0-f169.google.com with SMTP id o21so48651384wrb.2
 for <kvmarm@lists.cs.columbia.edu>; Thu, 06 Apr 2017 12:07:39 -0700 (PDT)
In-Reply-To: <20170406190727.5624-1-alex.bennee@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: drjones@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VGhpcyBpcyBmYWlybHkgZGlyZWN0IHdheSBvZiBlbnN1cmluZyB0aGUgdGFyZ2V0IGJ1aWxkIGRp
cmVjdG9yaWVzIGFyZQpjcmVhdGVkIGJlZm9yZSB3ZSBidWlsZCBhIGJpbmFyeSBibG9iLiBta2Rp
ciAtcCBmYWlscyBncmFjZWZ1bGx5IGlmCnRoZSBkaXJlY3RvcnkgaXMgYWxyZWFkeSB0aGVyZS4K
ClNpZ25lZC1vZmYtYnk6IEFsZXggQmVubsOpZSA8YWxleC5iZW5uZWVAbGluYXJvLm9yZz4KLS0t
CiBNYWtlZmlsZSB8IDUgKysrKysKIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKykKCmRp
ZmYgLS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCmluZGV4IDc4MTE4NmUuLjU2NTk4ZGYgMTAw
NjQ0Ci0tLSBhL01ha2VmaWxlCisrKyBiL01ha2VmaWxlCkBAIC03OSw4ICs3OSwxMyBAQCAkKExJ
QkZEVF9hcmNoaXZlKTogJChhZGRwcmVmaXggJChMSUJGRFRfb2JqZGlyKS8sJChMSUJGRFRfT0JK
UykpCiAJJChBUikgcmNzICRAICReCiAKICUubzogJS5TCisJbWtkaXIgLXAgJChkaXIgJEApCiAJ
JChDQykgJChDRkxBR1MpIC1jIC1ub3N0ZGxpYiAtbyAkQCAkPAogCislLm86ICUuYworCW1rZGly
IC1wICQoZGlyICRAKQorCSQoQ0MpICQoQ0ZMQUdTKSAtYyAtbyAkQCAkPAorCiAtaW5jbHVkZSAq
Ly4qLmQgKi8qLy4qLmQKIAogYWxsOiAkKHNoZWxsIGdpdCAtQyAkKFNSQ0RJUikgcmV2LXBhcnNl
IC0tdmVyaWZ5IC0tc2hvcnQ9OCBIRUFEID5idWlsZC1oZWFkIDI+L2Rldi9udWxsKQotLSAKMi4x
MS4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwprdm1h
cm0gbWFpbGluZyBsaXN0Cmt2bWFybUBsaXN0cy5jcy5jb2x1bWJpYS5lZHUKaHR0cHM6Ly9saXN0
cy5jcy5jb2x1bWJpYS5lZHUvbWFpbG1hbi9saXN0aW5mby9rdm1hcm0K
