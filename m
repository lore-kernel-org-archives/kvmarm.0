Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A36515B9
	for <kvmarm@lists.linux.dev>; Tue, 11 Oct 2022 01:06:40 +0000 (UTC)
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-355ae0f4d3dso118872007b3.14
        for <kvmarm@lists.linux.dev>; Mon, 10 Oct 2022 18:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+2DRG2ktbVgPO8gWevB+QacaOchvfaRovAISZPDw15A=;
        b=Ru9bE6+5i93s4ljKiceTT8ECQbHky9nEIOqC8q7N246aJaSCSRd6yJpd3YA9r1JH3q
         MZNmq1Rh8HknqDV5/Y2ef3KeOA7gbWjKkOJjtZKLNy6CwzObUCvwuJ94MZUdQIdIt3t5
         rld6OQuiY7EwKvi6HlTVjSt8Zzn8vTi/7K8RkPUIaQm+SIfAYNXoQc2gpna93DMy6OhN
         S+TjEJvpHNq292kKLI8g5vsyjiA4WSQ3iBMt7uYFt0nSjVAfsB56XIbr5tgEoyM6Uurs
         Q3Wcm3O2LaM+77RJBgCbdjEBwKVFy++ZvYW3DeyDmySmR7oaC3hawVRK/q2WuRrFpVwc
         h7iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2DRG2ktbVgPO8gWevB+QacaOchvfaRovAISZPDw15A=;
        b=svLl9CgkDkUdeO/fMVyMBvbc5/sp3mXO5DTbG22xjA36fiy1EAQQcnBeS6vzXyywHP
         MOrFftl40Ka0hpDxPA3r9hHnVse7hYqOJ9R+MEwLrmSvNvFUpAZwHnWkIf/zwf2UhWyH
         VQ4eLqoPcXpYsgccJUh8JuWvqKjjeRy9DycoAs2sv25/MSD9oQpKg4wVpqKkl7MgVgqV
         skWDXziFBEEf6hXbPW2OSmTF8opcfwPtdjSNthrhMBC7hszfNsHW8V0G5RpHtaoXN2DH
         gx1nqIG2CptbfR47uJBnmpn1ZfvUb9GHTfEoI6nWDULF2KfD7rUFn6OyJbVBg3fxEYEq
         ZZNw==
X-Gm-Message-State: ACrzQf0QZTL7OhRgvcF/AZmcRyC6YgQIjdpC6UDgBRq2HBB6Yt1qF+/K
	KKB0vd8jS1l9buftyMVUZYlo176E2u5f1w==
X-Google-Smtp-Source: AMsMyM519m9aB8GgfmipRWMBbUudlcoeRl8tTANXBJmjT5KugghKlNS7g1jd54VKWTbbPMxzI7dyinv9UFoveA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a0d:d78c:0:b0:360:bbf0:ef88 with SMTP id
 z134-20020a0dd78c000000b00360bbf0ef88mr8633791ywd.206.1665450399492; Mon, 10
 Oct 2022 18:06:39 -0700 (PDT)
Date: Tue, 11 Oct 2022 01:06:17 +0000
In-Reply-To: <20221011010628.1734342-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20221011010628.1734342-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221011010628.1734342-4-ricarkol@google.com>
Subject: [PATCH v9 03/14] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete()
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
	andrew.jones@linux.dev
Cc: pbonzini@redhat.com, maz@kernel.org, seanjc@google.com, 
	alexandru.elisei@arm.com, eric.auger@redhat.com, oupton@google.com, 
	reijiw@google.com, rananta@google.com, bgardon@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, 
	Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20221011010617.OB2KsO5tGztannePo91Qu-SUnFmPpwvCpnx-l4azeNg@z>

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Oliver Upton <oupton@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f1cb1627161f..19e37fb7de7c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -586,6 +586,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+	if (region->fd >= 0) {
+		/* There's an extra map when using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(!ret, __KVM_SYSCALL_ERROR("munmap()", ret));
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.38.0.rc1.362.ged0d419d3c-goog

