Received: from out-184.mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C85C1EA74
	for <kvmarm@lists.linux.dev>; Fri, 26 Jan 2024 14:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706279067; cv=none; b=ClGbTyMOrSiEMIIuVHqU4bNTHDyoWrTPPWIH0FOHdF6PoWTLS+a83l5yOQ14uFROf/JHeUvipcpv4R8Vv2ZAWx1JSPYxg9vPeWstflxOu2zDHg04hdEN+t5plMN5qD/VYZ7bYAUL0+oENJVITB345QODTE86LpY0YEJsj4wyF30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706279067; c=relaxed/simple;
	bh=l1H1ayVgtr0y/F9BTxnc/6VhhP1h6adG+2QUfjicTZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=dhHzm/apWj0+DpyUt7RnOgbIwKmuvGW29RzpLrQ2/0yvIrljOidNLB2sDho/bL5jTHet+sEAtz4qYAaVMA4IhMTHO11Ha5XJDPb451pnV9i1nWVQ/T2tR+3pyFfn0uUBYJow1XnrPvwzKoCNXdBcX86rQLQ+kg/NQcc39dQWhHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=TRtF+z1e; arc=none smtp.client-ip=95.215.58.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="TRtF+z1e"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1706279064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sKLWTFHf0UYVnJ+oUmmhwMrq46laxuqPb1YHaaLZsb4=;
	b=TRtF+z1e3GThrswZDDX9TUDilpV/ELFcwpv+58PbbPchgX8yDmTO018bgI4QyqaNPW1Rgf
	oUcDEKHWwtSmNUzPPXPDx7nWsExfyrQPcyUO4gXUZvSWDxKRptoB/M+KBsalNNG6VhMj/R
	WVYKs0bvR/MpN5xkd0MkP1w+FXhUqMU=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: ajones@ventanamicro.com,
	anup@brainfault.org,
	atishp@atishpatra.org,
	pbonzini@redhat.com,
	thuth@redhat.com,
	alexandru.elisei@arm.com,
	eric.auger@redhat.com
Subject: [kvm-unit-tests PATCH v2 21/24] lib: Add strcasecmp and strncasecmp
Date: Fri, 26 Jan 2024 15:23:46 +0100
Message-ID: <20240126142324.66674-47-andrew.jones@linux.dev>
In-Reply-To: <20240126142324.66674-26-andrew.jones@linux.dev>
References: <20240126142324.66674-26-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

We'll soon want a case insensitive string comparison. Add toupper()
and tolower() too (the latter gets used by the new string functions).

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 lib/ctype.h  | 10 ++++++++++
 lib/string.c | 14 ++++++++++++++
 lib/string.h |  2 ++
 3 files changed, 26 insertions(+)

diff --git a/lib/ctype.h b/lib/ctype.h
index 48a9c16300f8..45c96f111e19 100644
--- a/lib/ctype.h
+++ b/lib/ctype.h
@@ -37,4 +37,14 @@ static inline int isspace(int c)
         return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\v' || c == '\f';
 }
 
+static inline int toupper(int c)
+{
+	return islower(c) ? c - 'a' + 'A' : c;
+}
+
+static inline int tolower(int c)
+{
+	return isupper(c) ? c - 'A' + 'a' : c;
+}
+
 #endif /* _CTYPE_H_ */
diff --git a/lib/string.c b/lib/string.c
index 6d8a6380db92..ab6a724a3144 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -54,11 +54,25 @@ int strncmp(const char *a, const char *b, size_t n)
 	return 0;
 }
 
+int strncasecmp(const char *a, const char *b, size_t n)
+{
+	for (; n--; ++a, ++b)
+		if (tolower(*a) != tolower(*b) || *a == '\0')
+			return tolower(*a) - tolower(*b);
+
+	return 0;
+}
+
 int strcmp(const char *a, const char *b)
 {
 	return strncmp(a, b, SIZE_MAX);
 }
 
+int strcasecmp(const char *a, const char *b)
+{
+	return strncasecmp(a, b, SIZE_MAX);
+}
+
 char *strchr(const char *s, int c)
 {
 	while (*s != (char)c)
diff --git a/lib/string.h b/lib/string.h
index 758dca8af36a..a28d75641530 100644
--- a/lib/string.h
+++ b/lib/string.h
@@ -15,6 +15,8 @@ extern char *strcat(char *dest, const char *src);
 extern char *strcpy(char *dest, const char *src);
 extern int strcmp(const char *a, const char *b);
 extern int strncmp(const char *a, const char *b, size_t n);
+int strcasecmp(const char *a, const char *b);
+int strncasecmp(const char *a, const char *b, size_t n);
 extern char *strchr(const char *s, int c);
 extern char *strrchr(const char *s, int c);
 extern char *strchrnul(const char *s, int c);
-- 
2.43.0

