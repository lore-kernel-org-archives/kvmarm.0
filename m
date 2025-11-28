Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0D923B62B
	for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 17:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764352343; cv=none; b=cHux+uAHbWRKCFQ2oKT1MrPTdh1xTEuoqeZ0BvcwVrc9/LAkVgHrb28CxU4Sqtu3p7EhitE3zCXPJw6p9a/0XRRxv6WCMrj3d0wJotiD8PYAsvOoHnS0HVoIDsJabdAyKpwqHLvsSxQoTGc0qg0607eBM9eof+zVeuUmj0PweJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764352343; c=relaxed/simple;
	bh=GkebHRZ4hW0W7hKq0Uj4FDaIkukgfjcfiLZIR/1thWU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pWqH9+AXkOgwIDlQkANI3zLxEpK1D8iX8t8XlZnmjbgtR1DSj7HhPBzv6uCLnqhTOoawHFdd4lDAnvCsBsKW54RUwKQx9dL28JRBI9xp7GT+/Gg6l8QI4sAykq8kzQV/NRuNqKtRRnI5k77ZYNRappjWRIFq3nUjwCQ6ergFiOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hsS4YpFS; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hsS4YpFS"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477ba2c1ca2so23692465e9.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Nov 2025 09:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764352339; x=1764957139; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oAfyF823/XbGGGKg2P6nxUijTsKpVqaSaPrfyNHwf9s=;
        b=hsS4YpFSCgC0eK/kzfDXl+IM8ykWKh5W4HAR7HHqOwP1KXysP0Wt5WXbMooJn19EWD
         T5SgLDIN7xWoK+0HXKy938PLBMmAEbO33+pM7780Rkqir7rYo/WJCaGH5/ISnWpMLy5F
         lQHfzJdrquEeFradtjhJIz4nnoUCrAfzTeIBUDuSiNpBQxKMinrLO24kEV/pjhNSadQX
         tgoBXmW2q/8RtkX/Bye3ZaLJIMT8WqoEtjKhk4RtZLOG2UGm3u3T0ZnlBwI3vFFZy960
         mraXleyz/r3dur1axZmFI8vs5XRQ2TY6UcsiTtJMho/i9pMXbDpCYIJ04wfOfulZkGDv
         rKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764352339; x=1764957139;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oAfyF823/XbGGGKg2P6nxUijTsKpVqaSaPrfyNHwf9s=;
        b=LCm/2HP6g1gnLWVp8albZ/REQ2d7I+jRz6WpwoScj9Mh0VkNwHqWdkio+ekZMArg15
         6/OrvtDPI1MuCTMtN0pzkRhasFODXm4H3wR5dodBkS7liK+3Gda/PpWp5RmXnvWs9KBT
         XoVqHLV76qB8L2oFPQE5ZTyBQPhKgB1OJ8Y1adkJmz7dJrjWntHSljW7XDS58wAQlpyj
         TjPH7Z+DoLGT+lmSXdz6Lm+m4ntVyhk4j+uZ7MUxe8E985hj3wWAFtAxqALFDYK06N2H
         +Atz4LHa//q6w4JIGA785Gl9QExsP/mNt9FsD53sAYHiRTfFa4p5oMyRKduF2FYKNbJH
         dXxg==
X-Forwarded-Encrypted: i=1; AJvYcCV8uT5L3RDSdo4AoEjQhCEAav9dqPpjsT3dtVH1GkacibWOeap9eJXpos8popyStI+x5OJkv+k=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBjP3bN3DokNVrYQnTvzivnH9Jz+cyObovO/dDQeuoZ1coWrC7
	ROA9JoM9g5LjqNo/Z4WuyGaj5qYQ/5zlQqnn79NknMeMFWHd03NPZFyR
X-Gm-Gg: ASbGncsfEeccXn7z7g6xYZ68E1jyyWM98rsByaNL0skKdQUMmeSEQ+Z4TddNt40Ices
	XUe0W5OMapjST/Vo9ENMORTeDIYAoakNgUfzLtCAxGwtvrKjoM6vLOObPB1WmsFxaDRk8TnwIbR
	N/B3yPgOx8YbL2s8zGUa2HjP/11yl6OCF8cWqB8V95LECf/l8uh8cRLyB2ekwNSoR8cR60EMBXX
	7l2L6k8Qo6Elsq8BT9HIo3HkLr7FwtWywMkC2QGKas8R0mtdZcVlyJZvvp4ik1xK+YLhfaiFWT2
	dis+qI/9wdQxUGl0i6yBo2591m8wH02G0mz6I/WYlPjolan/f5GLQt6oUjfbn1IQZkga+ma0lF7
	CR0hXj6/dd6mt/uaCcK/TpGZR6uoXjuZVyXGAheQVcxYZHthhxqlA+e35qX0leH2WS4XPCN/VHI
	+LoeXDumA3aw==
X-Google-Smtp-Source: AGHT+IFNrav6emQa7eo4LXuc9QahSL2PszCgaxJFgT0UH28eKJZFTLEzFFZCoVSa6zVdulqINe9u9g==
X-Received: by 2002:a05:600c:4e8c:b0:477:8b77:155e with SMTP id 5b1f17b1804b1-47904af05b5mr178200545e9.15.1764352338440;
        Fri, 28 Nov 2025 09:52:18 -0800 (PST)
Received: from localhost ([87.254.0.133])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-47913870b38sm33438875e9.15.2025.11.28.09.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:52:18 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] KVM: arm64: Fix spelling mistake "Unexpeced" -> "Unexpected"
Date: Fri, 28 Nov 2025 17:51:24 +0000
Message-ID: <20251128175124.319094-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a TEST_FAIL message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 tools/testing/selftests/kvm/arm64/at.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/at.c b/tools/testing/selftests/kvm/arm64/at.c
index acecb6ab5071..c8ee6f520734 100644
--- a/tools/testing/selftests/kvm/arm64/at.c
+++ b/tools/testing/selftests/kvm/arm64/at.c
@@ -137,7 +137,7 @@ static void run_test(struct kvm_vcpu *vcpu)
 			REPORT_GUEST_ASSERT(uc);
 			return;
 		default:
-			TEST_FAIL("Unexpeced ucall: %lu", uc.cmd);
+			TEST_FAIL("Unexpected ucall: %lu", uc.cmd);
 		}
 	}
 }
-- 
2.51.0

